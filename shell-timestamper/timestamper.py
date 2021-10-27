#!/usr/bin/python3

"""
timestamper
Author: David Chang
Last Revision: Oct 27, 2020
"""

import argparse
import sys

import datetime

#import os
import subprocess
import signal

print_ = sys.stdout.write
flush = sys.stdout.flush

def wrap_char(in_pipe, format_str):
    #  function `wrap_char` {{{ # 
    """
    in_pipe - io.TextIOBase
    format_str - str
    """

    is_new_line = True
    while True:
        try:
            ch = in_pipe.read(1)
            if ch=="":
                break
            if is_new_line:
                print_("[{:}]\t".format(datetime.datetime.now().strftime(format_str)))
                is_new_line = False
            print_(ch)
            flush()
            is_new_line = ch=="\n"
        except:
            break
    #  }}} function `wrap_char` # 

def wrap_line(in_pipe, format_str):
    #  function `wrap_line` {{{ # 
    """
    in_pipe - io.TextIOBase
    format_str - str
    """

    for l in in_pipe:
        print_("[{:}]\t{:}".format(
                datetime.datetime.now().strftime(format_str),
                l))
    #  }}} function `wrap_line` # 

def sigterm_handler(signal_number, frame):
    #  function `sigterm_handler` {{{ # 
    """
    signal_number - int
    frame - None or frame object
    """

    if signal_number==15:
        raise KeyboardInterrupt(15)
    #  }}} function `sigterm_handler` # 

def main():
    signal.signal(signal.SIGTERM, sigterm_handler)

    parser = argparse.ArgumentParser()
    #parser.add_argument("command", nargs="*", type=str)
    parser.add_argument("--format", "-f", default="%Y-%m-%d %H:%M:%S.%f", type=str,
        help="""Time Format Specification from Python 3 datetime module,
which is derived from the 1989 C Standard and ISO 8601 Standard.""")
    parser.add_argument("--buffer-mode", "-m", default="c", type=str,
        choices=["c", "L"], help="Buffer Mode. \"c\" for char, aka unbuffered; \"L\" for line buffered.")

    try:
        args_split_index = sys.argv.index("--")
        command = sys.argv[args_split_index+1:]
        args = parser.parse_args(sys.argv[1:args_split_index])
    except ValueError:
        command = []
        args = parser.parse_args()

    format_str = args.format
    wrap = wrap_char if args.buffer_mode=="c" else wrap_line

    exit_code = None

    print("[Started at {:}]".format(datetime.datetime.now().strftime(format_str)))

    if len(command)>0:
        try:
            with subprocess.Popen(command, stdout=subprocess.PIPE, text=True) as prc:
                wrap(prc.stdout, format_str)
        except KeyboardInterrupt:
            prc.terminate()
            exit_code = prc.returncode
        finally:
            print("[Terminated at {:}]".format(datetime.datetime.now().strftime(format_str)))
            if exit_code is None:
                exit_code = prc.returncode
            exit(exit_code)
    else:
        try:
            wrap(sys.stdin, format_str)
        except KeyboardInterrupt as e:
            exit_code = -int(e.args[0]) if len(e.args)>0 else -2
        finally:
            if exit_code is None:
                exit_code = 0
            print("[Terminated at {:}]".format(datetime.datetime.now().strftime(format_str)))
            exit(exit_code)

if __name__ == "__main__":
    main()
