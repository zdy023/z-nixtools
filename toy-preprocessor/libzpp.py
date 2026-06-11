#!/usr/bin/python3

"""
Composed by Danyang Zhang
Last Revision: Apr 2026
"""

# Test:
# ./zpp -m C test.txt.orig -o output.txt
# ./zpp -m C --def ABC test.txt.orig -o output.txt
# ./zpp -m C --def got=获得 test.txt.orig -o output.txt
# ./zpp -m C --def ABC=321 test.txt.orig -o output.txt
# ./zpp -m C --def 'ABC=/(?<!^)ABC/321/' test.txt.orig -o output.txt
# ./zpp -m C --def 'ABC=/(?<!^)ABC/321/' --def NUM=2 test.txt.orig -o output.txt
# ./zpp -m C --def 'ABC=/(?<!^)ABC/321/' --def NUM=3 test.txt.orig -o output.txt
# ./zpp -m C --def 'LOOP=/(?<!^)LOOP\b/a b c/' test.txt.orig -o output.txt
# ./zpp -m C --def 'LOOP=/(?<!^)LOOP\b/a:b:c/' test.txt.orig -o output.txt
# ./zpp -m C test.txt.orig -o output.txt
# ./zpp -m C --def NONE=GIRL test.txt.orig -o output.txt
# ./zpp -m C --def NONE test.txt.orig -o output.txt

import argparse
import collections
import itertools
import logging
import operator
import os.path
import re
from numbers import Number
from typing import Deque, Dict, Iterable, List, Match, Optional, Pattern, TextIO, Tuple, TypedDict, Union, cast

logger = logging.Logger("zpp")

line_prefix_mark_pattern: Pattern[str] = re.compile(r"(?<!\\)<")
line_suffix_mark_pattern: Pattern[str] = re.compile(r"(?<!\\)>")
line_subs_mark_pattern: Pattern[str] = re.compile(r"(?<!\\)/")
def parse_include_arguments(command_line: str) ->\
        Tuple[ Optional[str], Optional[str]
             , Optional[str], Optional[str]
             , Optional[Tuple[str, str]], str
             ]:
    """
    Args:
        command_line (str): the remaining arguments to parse

    Returns:
        Optional[str]: prefix definition
        Optional[str]: suffix definition
        Optional[str]: line prefix to prepend
        Optional[str]: line suffix to append
        Optional[Tuple[str, str]]: line substitution rule
        str: remaining command line
    """

    if command_line.startswith("-"):
        items = command_line.split(maxsplit=1)
        return items[0][1:], None, None, None, None, items[1]
    if command_line.startswith("+"):
        items = command_line.split(maxsplit=1)
        return None, items[0][1:], None, None, None, items[1]
    if command_line.startswith("<"):
        including_prefix: str
        remaining: str
        including_prefix, remaining = _get_wrapped_arguments( line_prefix_mark_pattern
                                                            , command_line, 1
                                                            )
        return None, None\
             , including_prefix.replace(r'\<', '<'), None\
             , None, remaining.strip()
    if command_line.startswith(">"):
        including_suffix: str
        remaining: str # type: ignore[no-redef]
        including_suffix, remaining = _get_wrapped_arguments( line_suffix_mark_pattern
                                                            , command_line, 1
                                                            )
        return None, None\
             , None, including_suffix.replace(r'\>', '>')\
             , None, remaining.strip()
    if command_line.startswith("/"):
        substitution_pattern: str
        substitution_replacement: str
        remaining: str # type: ignore[no-redef]
        substitution_pattern, remaining = _get_wrapped_arguments( line_subs_mark_pattern
                                                                , command_line, 1
                                                                )
        substitution_replacement, remaining = _get_wrapped_arguments( line_subs_mark_pattern
                                                                    , remaining, 0
                                                                    )
        return None, None, None, None\
             , (substitution_pattern.replace(r'\/', '/'), substitution_replacement.replace(r'\/', '/'))\
             , remaining.strip()
    return None, None, None, None, None, command_line

def _get_wrapped_arguments(pattern: Pattern[str], command_line: str, search_position: int = 1) -> Tuple[str, str]:
    #  _get_wrapped_arguments {{{ # 
    endmarkmatch: Optional[Match[str]] = pattern.search(command_line, search_position)
    if endmarkmatch is None:
        raise ValueError("Invalid syntax. Missing the end character %s" % pattern.pattern)
    endposition: int = endmarkmatch.end()
    return command_line[search_position:endposition-1], command_line[endposition:]
    #  }}} _get_wrapped_arguments # 

def parse_number(number_str: str) -> Union[None, int, float]:
    try:
        number: int = int(number_str)
        return number
    except ValueError:
        pass
    try:
        number: float = float(number_str) # type: ignore[no-redef]
        return number
    except ValueError:
        pass
    logger.warning("`%s` is neither interger nor float.", number_str)
    return None

def _print_plainline( line: str, macros: Dict[str, Union[str, Tuple[str, str, str]]], line_subs: List[Tuple[str, str]]
                    , line_prefix: str, line_suffix: str
                    ) -> str:
    #  function _print_plainline {{{ # 
    while True:
        nb_total_substituions: int = 0
        nb_substituions: int = 0
        for mcr, mcr_val in macros.items():
            if isinstance(mcr_val, str):
                new_line, nb_substituions = re.subn(r"\b" + mcr + r"\b", mcr_val, line, flags=re.ASCII)
            else:
                # mcr_val[0]: regex
                # mcr_val[1]: substitution
                # mcr_val[2]: regex flags, one letter per flag
                new_line, nb_substituions = re.subn(mcr_val[0], mcr_val[1], line, flags=all(getattr(re, fl) for fl in mcr_val[2]))
            if new_line==line:
                nb_substituions = 0
            line = new_line
            nb_total_substituions += nb_substituions
        if nb_total_substituions==0:
            break
    while True:
        nb_substituions = 0
        for ptn, sstt in line_subs:
            new_line, nb_substituions = re.subn(ptn, sstt, line)
            if new_line==line:
                nb_substituions = 0
            line = new_line
        if nb_substituions==0:
            break
    return line_prefix + line + line_suffix + "\n"
    #  }}} function _print_plainline # 

class ModificationDict(TypedDict, total=False):
    line_prefix: str
    line_suffix: str
    line_subs: List[Tuple[str, str]]

_condition_pattern = re.compile(r"(?P<if>if|elif)(?P<not>n?)(?P<rel>def|eqn?|[lg][et])")
def include( input_file: Iterable[str]
           , output_file: TextIO
           , configs: Dict[str, str]
           , states: Dict[str, Dict[str, Union[str, Tuple[str, str, str]]]]
           , if_stack: Deque[List[bool]]
           , modifications: ModificationDict
           ):
    #lizard forgives(cyclomatic_complexity)
    #  function `include` {{{ # 
    """
    Args:
        input_file: iterable of str
        output_file: object supporting `write` accepting str
        configs: dict like
          {
            "prefix": str,
            "suffix": str,
            "path": str
          }
        states: dict like
          {
            "macros": dict like {str: str, str: (str, str, str)}
          }
        if_stack: collections.deque of [bool, bool]
          - the first item indicates whether the current if-block has been
            matched ever
          - the second item indicates whether the current if-block is matched
            right now
        modifications (Dict[str, Union[str, List[Tuple[str, str]]]]): dict like
          {
            "line_prefix": str
            "line_suffix": str
            "line_subs": list of tuple like (str, str)
          }
    """

    macros = states["macros"]

    prefix = configs["prefix"]
    suffix = configs["suffix"]
    path = configs["path"]

    line_prefix: str = modifications.get("line_prefix", "")
    line_suffix: str = modifications.get("line_suffix", "")
    line_subs: List[Tuple[str, str]] = modifications.get("line_subs", [])

    looping_block: List[str] = []
    loop_depth = 0
    # [[substitutions for macro 1], [substitutions for macro 2], ...]
    loop_substitutions: List[Union[List[str], List[Tuple[str, str, str]]]] = []
    loop_macro_name: List[str] = []

    for l in input_file:
        # assume there is a trailing '\n'
        unstripped_line = l[:-1]
        l = l.strip()

        # Extract command
        if l.startswith(prefix) and l.endswith(suffix):
            candidate = l[len(prefix):-len(suffix)] if len(suffix)>0 else l[len(prefix):]
            candidate = candidate.strip()

            command = candidate.split(maxsplit=1)
        else:
            command = []

        # First handle in-loop logics
        if loop_depth>0:
            if len(command)>=1:
                if command[0]=="for":
                    loop_depth += 1
                elif command[0]=="endfor":
                    loop_depth -= 1
            if loop_depth>0:
                looping_block.append(unstripped_line + "\n")
            else:
                macro_backup: Dict[str, Union[None, str, Tuple[str, str, str]]] = {}
                for l_mcr_n in loop_macro_name:
                    macro_backup[l_mcr_n] = macros.get(l_mcr_n, None)
                for fll in itertools.zip_longest(*loop_substitutions, fillvalue=""):
                    for l_mcr_n, fll_val in zip(loop_macro_name, fll):
                        macros[l_mcr_n] = fll_val # type: ignore[assignment]
                    include(looping_block, output_file, configs, states, if_stack, modifications)
                for l_mcr_n in loop_macro_name:
                    if macro_backup[l_mcr_n] is not None:
                        macros[l_mcr_n] = macro_backup[l_mcr_n] # type: ignore[assignment]
                    else:
                        if l_mcr_n in macros:
                            del macros[l_mcr_n]

                loop_substitutions = []
                loop_macro_name = []

        # Then handle condition logics
        elif len(command)>=1 and command[0]=="else":
            if_stack[-1][1] = if_stack[-2][1] and not if_stack[-1][0]
            if_stack[-1][0] = if_stack[-2][1]
        elif len(command)>=1 and command[0]=="endif":
            if_stack.pop()
        else:
            match_ = _condition_pattern.match(command[0]) if len(command)>=1 else None
            if match_ is not None:
                if match_["if"]=="if":
                    if_stack.append([False, False])
                if if_stack[-1][0]:
                    if_stack[-1][1] = False
                else:
                    if not if_stack[-2][1]:
                        condition = False
                    else:
                        if match_["rel"]=="def":
                            condition = command[1] in macros
                            mask = True
                        else:
                            condition_items: List[str] = command[1].split(maxsplit=1)
                            macro_name: str = condition_items[0]
                            macro_value: str = condition_items[1] if len(condition_items)>1 else ""
                            mask = macro_name in macros
                            real_value: Union[str, Tuple[str, str, str]] = macros.get(macro_name, "")
                            if isinstance(real_value, tuple):
                                real_value = cast(str, real_value[1])

                            if match_["rel"]=="eq":
                                condition = mask and real_value==macro_value
                            else:
                                ref_number: Optional[Number] = parse_number(macro_value) # type: ignore[assignment]
                                real_number: Optional[Number] = parse_number(real_value) # type: ignore[assignment]
                                mask = mask and ref_number is not None\
                                            and real_number is not None
                                if match_["rel"]=="eqn":
                                    condition = mask and real_number==ref_number
                                else:
                                    condition = mask and getattr(operator, match_["rel"])(real_number, ref_number)

                        if match_["not"]=="n":
                            condition = mask and not condition
                    if_stack[-1] = [condition, condition]

            # Finally, other logics
            elif if_stack[-1][1]:
                if len(command)<1:
                    output_file.write(_print_plainline(unstripped_line, macros, line_subs, line_prefix, line_suffix))
                elif command[0]=="define":
                    arguments = command[1].split(maxsplit=1)
                    macros[arguments[0]] = arguments[1] if len(arguments)>1 else ""
                elif command[0]=="defineR":
                    macro_name: str # type: ignore[no-redef]
                    remaining: str
                    macro_name, remaining = command[1].split(maxsplit=1)
                    assert remaining.startswith("/"), "Invalid syntax for defineR: %s" % command[1]
                    regex: str
                    flags: str
                    replacement: str
                    regex, remaining = _get_wrapped_arguments(
                                        line_subs_mark_pattern
                                      , remaining, 1
                                      )
                    flags, replacement = _get_wrapped_arguments(
                                            re.compile(r'\s')
                                          , remaining, 0
                                          )
                    regex = regex.replace(r'\/', '/')
                    flags = flags.strip()
                    replacement = remaining.strip()
                    macros[macro_name] = (regex, replacement, flags)
                elif command[0]=="undef":
                    if command[1] in macros:
                        del macros[command[1]]

                elif command[0]=="include":
                    in_prefix = prefix
                    in_suffix = suffix
                    in_line_prefix = ""
                    in_line_suffix = ""
                    in_line_subs: List[Tuple[str, str]] = []

                    prefix_, suffix_, line_prefix_, line_suffix_, new_line_sub, remaining = parse_include_arguments(command[1])
                    # parse the arguments iteratively
                    while True:
                        if prefix_ is not None:
                            in_prefix = prefix_
                        elif suffix_ is not None:
                            in_suffix = suffix_
                        elif line_prefix_ is not None:
                            in_line_prefix = line_prefix_
                        elif line_suffix_ is not None:
                            in_line_suffix = line_suffix_
                        elif new_line_sub is not None:
                            in_line_subs.append(new_line_sub)
                        else:
                            break

                        prefix_, suffix_, line_prefix_, line_suffix_, new_line_sub, remaining = parse_include_arguments(remaining)

                    if remaining.startswith("#"):
                        include_file: str = remaining.lstrip("#") # use "#" to distinguish an absolute path from the replacement rules
                    else:
                        include_file: str = os.path.join(path, remaining) # type: ignore[no-redef]
                    in_path = os.path.dirname(include_file)

                    with open(include_file) as incl_f:
                        include( incl_f, output_file
                               , configs={ "prefix": in_prefix
                                         , "suffix": in_suffix
                                         , "path": in_path
                                         }
                               , states={"macros": macros}
                               , if_stack=if_stack
                               , modifications={ "line_prefix": line_prefix + in_line_prefix
                                               , "line_suffix": line_suffix + in_line_suffix
                                               , "line_subs": line_subs + in_line_subs
                                               }
                               )

                elif command[0]=="for":
                    arguments: List[str] = command[1].split(maxsplit=1) # type: ignore[no-redef]
                    loop_macro_name = arguments[0].split(",")
                    for l_mcr_n, sep in itertools.zip_longest(loop_macro_name, arguments[1:1+len(loop_macro_name)]):
                        if l_mcr_n in macros:
                            macro_definition: Union[str, Tuple[str, str, str]] = macros[l_mcr_n]
                            if isinstance(macro_definition, str):
                                macro_value: str = macro_definition # type: ignore[no-redef]
                            else:
                                macro_value: str = macro_definition[1] # type: ignore[no-redef]
                            fillers: List[str] = macro_value.split(sep)
                        else:
                            macro_definition = ""
                            fillers = []

                        if isinstance(macro_definition, tuple):
                            loop_substitutions.append(
                                    [ (macro_definition[0], fll, macro_definition[2])
                                  for fll in fillers
                                    ]
                                )
                        else:
                            loop_substitutions.append(fillers)

                    loop_depth += 1
                    looping_block = []
                else:
                    output_file.write(_print_plainline(unstripped_line, macros, line_subs, line_prefix, line_suffix))
    #  }}} function `include` # 

MODE_DICT = {
        "H": {
            "prefix": "<!--",
            "suffix": "-->",
        },
        "T": {
            "prefix": "%",
            "suffix": ""
        },
        "C": {
            "prefix": "#",
            "suffix": ""
        },
        "J": {
            "prefix": "//",
            "suffix": ""
        }
    }

def preprocess( input_file: Iterable[str], output_file: TextIO
              , configs: Dict[str, str]
              , states: Dict[str, Dict[str, Union[str, Tuple[str, str, str]]]]
              ):
    """
    Args:
        input_file (Iterable[str]): input file as line sequence
        output_file (TextIO): output file
        configs (Dict[str, str]): dict like
          {
            "prefix": str,
            "suffix": str,
            "path": str
          }
          configuring the prefix, suffix, and working path
        states (Dict[str, Dict[str, str]): dict like
          {
            "macros": dict like {str: str, str: (str, str, str)}
          }
          defining macros
    """

    if_stack = collections.deque([[True, True]])
    include(input_file, output_file, configs, states, if_stack, {})

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument("--prefix", type=str, help="Prefix for preprocessing commands.")
    parser.add_argument("--suffix", type=str, help="Suffix for preprocessing commands.")
    parser.add_argument("--nosuffix", action="store_const", const="", dest="suffix",
        help="No suffices is in need.")
    parser.add_argument("--mode", "-m", default="H", type=str, choices=["H", "T", "C", "J"],
        help="""\
H: HTML Comment Mode, e.g., <!-- include a.js -->
T: TeX Comment Mode, e.g., %% define TeX \\LaTeX
C: C Preprocessing Instruction Mode, e.g., #define A_TOY_PREPROCESSOR
J: Java Comment Mode, e.g., // include class.java""")

    parser.add_argument("--def", action="append", type=str,
        help="Manually define a macro like \"ABC\" or \"ABC=LSP\" or \"ABC=/REGEX/SUB/\", \"=\" in macro name and definitions and \"/\" in definitions could be escaped by \"\\\"",
        dest="macro")

    parser.add_argument("file", type=str, help="Input file.")

    parser.add_argument("--output", "-o", default="/dev/stdout", type=str,
        help="Output file")

    args = parser.parse_args()

    mode_data = MODE_DICT[args.mode]
    prefix = mode_data["prefix"]
    suffix = mode_data["suffix"]

    if args.prefix is not None:
        prefix = args.prefix
    if args.suffix is not None:
        suffix = args.suffix

    definition_separator_pattern = re.compile(r"(?<!\\)=")
    real_equal_mark_pattern = re.compile(r"\\=")

    macros: Dict[str, Union[str, Tuple[str, str, str]]] = {}
    if args.macro:
        for mcr in args.macro:
            items = definition_separator_pattern.split(mcr, maxsplit=1)
            macro_name = real_equal_mark_pattern.sub("=", items[0])
            macro_value: str = real_equal_mark_pattern.sub("=", items[1]) if len(items)>1 else ""

            if macro_value.startswith("/") and macro_value.endswith("/"):
                regex: str
                replacement: str
                regex, replacement = line_subs_mark_pattern.split(macro_value[1:-1], maxsplit=1)
                macro_value: Tuple[str, str, str] = ( regex.replace(r'\/', '/') # type: ignore[no-redef]
                                                    , replacement.replace(r'\/', '/')
                                                    , ""
                                                    )
            else:
                macro_value: str = macro_value.replace(r'\/', '/') # type: ignore[no-redef]
            macros[macro_name] = macro_value

    path = os.path.dirname(args.file)

    if_stack = collections.deque([[True, True]])

    with open(args.file) as in_f,\
            open(args.output, "w") as out_f:
        include( in_f, out_f
               , configs={ "prefix": prefix
                         , "suffix": suffix
                         , "path": path
                         }
               , states={"macros": macros}
               , if_stack=if_stack
               , modifications={}
               )

if __name__ == "__main__":
    main()
