#!/usr/bin/python3

import argparse
from pathlib import Path
from typing import List, Dict
from typing import TextIO, Union
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
                input( "{:}\nPlease input the channels to output: "\
                        .format("\n".join(meta_lines))
                     ).strip()
    else:
        output_channels: str = args.output_channels.strip()

    declared_channels: Dict[str, str] = {}
    for mt_l in meta_lines:
        items: List[str] = mt_l[:-2].split(": ", maxsplit=1)
        declared_channels[items[0]] =\
                os.path.expanduser(
                        os.path.expandvars(
                            items[1] if os.path.isabs(items[1]) else os.fspath(input_file.parent/items[1])
                          )
                      )

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
        output_flows[ch] = open(declared_channels[ch], "w")

    modelines: List[str] = list(
                                filter( lambda l: l.endswith(" **")
                                      , source_lines
                                      )
                              )
    # 0 as ALL, output to all channels
    # -1 as MUTE, output to no channels
    # str as +XXX, output to dedicated channels
    blank_mode: Union[str, int] = 0
    if len(modelines)>0:
        modeline: str = modelines[0]
        modeline = modeline[:-3].strip()
        if modeline=="ALL":
            blank_mode = 0
        elif modeline=="MUTE":
            blank_mode = -1
        elif modeline[0]=="+":
            blank_mode = modeline[1:]
    if blank_mode==0:
        def write_blank(l: str):
            for fl in output_flows.values():
                fl.write(l + "\n")
    elif blank_mode==-1:
        def write_blank(l: str):
            pass
    else:
        def write_blank(l: str):
            for ch in blank_mode:
                if ch in output_flows:
                    output_flows[ch].write(l + "\n")

    for l in source_lines:
        if l.endswith(" *") or l.endswith(" **"):
            continue
        if l.endswith(">"):
            try:
                space_offset: int = l.rindex(" ")
                channels: str = l[space_offset+1:-1]
                for chnnl in channels:
                    if chnnl in output_flows:
                        output_flows[chnnl].write(l[:space_offset] + "\n")
            except ValueError:
                for fl in output_flows.values():
                    fl.write(l + "\n")
        elif l.endswith(" |"):
            for fl in output_flows.values():
                fl.write(l[:-2] + "\n")
        else:
            #for fl in output_flows.values():
                #fl.write(l + "\n")
            write_blank(l)

    for fl in output_flows.values():
        fl.flush()
        fl.close()

if __name__ == "__main__":
    main()
