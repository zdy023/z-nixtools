#!/usr/bin/python3

"""
remote_fcitx_vim_local_machine
Author: David Chang
Last Revision: Aug 27, 2020
"""

import socket
import signal
import subprocess
import os

import utils
import protocols

import time
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("address", type=str, help="The address of the remote host to connect to.")
parser.add_argument("--port", default=30002, type=int, help="The port of the remote host to connect to.")
parser.add_argument("--fcitx4", action="store_true", help="Use fcitx4 rather than fcitx5.")
args = parser.parse_args()

signal.signal(signal.SIGINT, utils.existence_handler)
signal.signal(signal.SIGTERM, utils.existence_handler)

fcitx_remote_command = "fcitx-remote" if args.fcitx4 else "fcitx5-remote"

fcitx_closed = -1
fcitx_deactivated = 0
fcitx_activated = 1

fcitx_closed_error_number = 1

def get_fcitx_status():
    """
    return int
      -1 - fcitx closed
      0 - fcitx deactivated
      1 - fcitx activated
    """

    fcitx_remote = subprocess.Popen(fcitx_remote_command,
            stdout=subprocess.PIPE, encoding="utf-8")
    status, _ = fcitx_remote.communicate()
    return int(status)-1

fcitx_statuses = {}

try:
    #session = socket.create_connection((args.address, args.port), source_address=("0.0.0.0", 30001))
    session = socket.create_connection((args.address, args.port))
    print("Connected.")
    while True:
        message = session.recv(64)
        message = bytes(filter((lambda b: b!=0), message))
        if len(message)==0:
            continue
        file_name = protocols.extract_file_name_from_mode_message(message)
        print("Received: {:}".format(str(message)))

        if protocols.is_insertion_mode_message(message):
            if file_name not in fcitx_statuses:
                fcitx_statuses[file_name] = fcitx_deactivated
            if fcitx_statuses[file_name] == fcitx_activated:
                os.system("{:} -o".format(fcitx_remote_command))
                print("On.")
        elif protocols.is_normal_mode_message(message):
            fcitx_statuses[file_name] = get_fcitx_status()
            os.system("{:} -c".format(fcitx_remote_command))
            print("Off.")
        elif protocols.is_closed_mode_message(message):
            if file_name in fcitx_statuses:
                del fcitx_statuses[file_name]
            print("Quitted.")

        time.sleep(0.1)
except KeyboardInterrupt:
    session.shutdown(socket.SHUT_RDWR)
    exit(0)
