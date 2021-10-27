#!/usr/bin/python3

"""
remote_fcitx_vim_sender
Author: David Chang
Last Revision: Aug 27, 2020
"""

import socket
import os
import os.path

import argparse

import protocols

parser = argparse.ArgumentParser()
parser.add_argument("message", type=str, choices=["NORMAL", "INSERTION", "CLOSED"], help="The mode message to be sent.")
parser.add_argument("filename", type=str, help="The underlying file name.")
args = parser.parse_args()

socket_file_not_exists_error_code = 1

socket_file = "/tmp/remote-fcitx-vim-socket.{:}.{:}".format(socket.gethostname(), os.getuid())
if not os.path.exists(socket_file):
    exit(socket_file_not_exists_error_code)
session = socket.socket(socket.AF_UNIX)
session.connect(socket_file)
session.setblocking(True)
if args.message=="NORMAL":
    session.sendall(protocols.normal_mode_message(args.filename))
elif args.message=="INSERTION":
    session.sendall(protocols.insertion_mode_message(args.filename))
else:
    session.sendall(protocols.closed_mode_message(args.filename))
session.shutdown(socket.SHUT_RDWR)
