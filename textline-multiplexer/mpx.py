#!/usr/bin/python3

import argparse
from pathlib import Path
from typing import List, Dict
from typing import TextIO, Callable, Any
import os.path
import logging
import os

logger = logging.getLogger("textline-textline-multiplexer")

def main():
    #  Argparse {{{ # 
    parser = argparse.ArgumentParser()
    parser.add_argument("-L", "--list-channels", action="store_true")
    parser.add_argument("-c", "--output-channels", action="store", type=str)
    parser.add_argument("-i", "--source", action="store", type=str, required=True)
    parser.add_argument( "--overwrite", action="store"
                       , default="warning", type=str
                       , choices=["warning", "fatal", "quiet", "ask"]
                       )
    args: argparse.Namespace = parser.parse_args()
    #  }}} Argparse # 

    input_file = Path(args.source)
    source_lines: List[str] = input_file.read_text().splitlines()
    meta_lines: List[str] = list(
                                filter( lambda l: l.endswith(" *")
                                      , source_lines
                                      )
                              )

    if args.list_channels:
        for mt_l in meta_lines:
            print(mt_l)
        exit(0)

    if args.output_channels is None or len(args.output_channels)==0:
        output_channels: str =\
                input( "{:}\nPlease input the channels to output (seperated by commas): "\
                        .format("\n".join(meta_lines))
                     ).strip()
    else:
        output_channels: str = args.output_channels.strip()
    output_channels: List[str] = output_channels.split(",")

    declared_channels: Dict[str, str] = {}
    declared_tags: Dict[str, str] = {}
    for i, mt_l in enumerate(meta_lines):
        items: List[str] = mt_l[:-2].split(": ", maxsplit=1)
        if len(items[0])==1:
            declared_tags[items[0]] = "_{:d}".format(i)
        declared_channels[items[0]] =\
                os.path.expanduser(
                        os.path.expandvars(
                            items[1] if os.path.isabs(items[1]) else os.fspath(input_file.parent/items[1])
                          )
                      )
    tag_translation_dict: Dict[str, str] = declared_tags.copy()
    tag_translation_dict['!'] = "_not"
    _not: Callable[[int], int] = lambda x: int(x==0)
    tag_translation_dict: Dict[int, str] = str.maketrans(tag_translation_dict)

    output_flows: Dict[str, TextIO] = {}
    for ch in output_channels:
        if os.path.exists(declared_channels[ch]):
            if args.overwrite=="warning":
                logger.warning("%s exists, will be overwriten", declared_channels[ch])
            elif args.overwrite=="fatal":
                logger.error("%s exists, exiting", declared_channels[ch])
                exit(2)
            elif args.overwrite=="ask":
                overwrites: str = input(
                                    "{:} exists, overwrites it? (y/N)".format(declared_channels[ch])
                                  ).strip()
                if len(overwrites)<1 or overwrites[0].lower!="y":
                    exit(2)
        channel_expression: str = ch.translate(tag_translation_dict)
        output_flows[channel_expression] = open(declared_channels[ch], "w")

    modelines: List[str] = list(
                                filter( lambda l: l.endswith(" **")
                                      , source_lines
                                      )
                              )
    # 0 as ALL, default with all the tags
    # -1 as MUTE, default with no tags
    # str as +XXX, default to specific tags
    default_tags: str = "".join(declared_tags)
    if len(modelines)>0:
        modeline: str = modelines[0]
        modeline = modeline[:-3].strip()
        logger.info("Using mode: %s", modeline)
        if modeline=="MUTE":
            default_tags = ""
        elif modeline[0]=="+":
            default_tags = modeline[1:]

    #blank_mode: Union[str, int] = 0
    #if len(modelines)>0:
        #modeline: str = modelines[0]
        #modeline = modeline[:-3].strip()
        #logger.info("Using mode: %s", modeline)
        #if modeline=="ALL":
            #blank_mode = 0
        #elif modeline=="MUTE":
            #blank_mode = -1
        #elif modeline[0]=="+":
            #blank_mode = modeline[1:]
    #else:
        #logger.info("Using mode: %s", "ALL")
    #if blank_mode==0:
        #def write_blank(l: str):
            #for fl in output_flows.values():
                #fl.write(l + "\n")
    #elif blank_mode==-1:
        #def write_blank(l: str):
            #pass
    #else:
        #def write_blank(l: str):
            #for ch in blank_mode:
                #if ch in output_flows:
                    #output_flows[ch].write(l + "\n")

    predefined_tags: str = ""
    for l_no, l in enumerate(source_lines):
        if l.endswith(" *") or l.endswith(" **"):
            continue

        # 1. parse tags
        if l.endswith(" <"):
            predefined_tags: str = l[:-2].strip()
            continue

        if len(predefined_tags)==0:
            if l.endswith(">"):
                try:
                    space_offset: int = l.rindex(" ")
                    tags: str = l[space_offset+1:-1]
                    line: str = l[:space_offset]
                except ValueError:
                    tags: str = default_tags
                    line: str = l
            elif l.endswith(" |"):
                tags: str = "".join(declared_tags)
                line: str = l[:-2]
            else:
                tags: str = default_tags
                line: str = l
        else:
            tags: str = predefined_tags
            line: str = l

        # 2. sent to channels
        tag_values: Dict[str, Any] = {val: 0 for t, val in declared_tags.items()}
        try:
            for t in tags:
                tag_values[declared_tags[t]] = 1
        except KeyError:
            logger.exception("Key Error @L%d: %s", l_no, line)
            exit(1)
        tag_values["_not"] = _not
        for fl in output_flows:
            #print(line, tags, tag_values, fl)
            if eval(fl, locals=tag_values)>0:
                output_flows[fl].write(line + "\n")

        #if l.endswith(">"):
            #try:
                #space_offset: int = l.rindex(" ")
                #channels: str = l[space_offset+1:-1]
                #for chnnl in channels:
                    #if chnnl in output_flows:
                        #output_flows[chnnl].write(l[:space_offset] + "\n")
            #except ValueError:
                #for fl in output_flows.values():
                    #fl.write(l + "\n")
        #elif l.endswith(" |"):
            #for fl in output_flows.values():
                #fl.write(l[:-2] + "\n")
        #else:
            ##for fl in output_flows.values():
                ##fl.write(l + "\n")
            #write_blank(l)

    for fl in output_flows.values():
        fl.flush()
        fl.close()

if __name__ == "__main__":
    main()
