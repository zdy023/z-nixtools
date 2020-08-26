#!/usr/bin/python3

import socket
import os

import argparse

import protocols

parser = argparse.ArgumentParser()
parser.add_argument("message", type=str, choices=["NORMAL", "INSERTION", "CLOSED"], help="The mode message to be sent.")
parser.add_argument("filename", type=str, help="The underlying file name.")
args = parser.parse_args()

socket_file = "/tmp/remote-fcitx-vim-socket.{:}.{:}".format(socket.gethostname(), os.getuid())
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
