#!/usr/bin/python3

"""
remote_fcitx_vim_daemon
Author: David Chang
Last Revision: Aug 27, 2020
"""

import signal
import os
import os.path

import socket
import tempfile

import time
import multiprocessing

import protocols
import utils

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--address", default="0.0.0.0", type=str, help="The address to bind with.")
parser.add_argument("--port", default=30002, type=int, help="The port to bind with.")
args = parser.parse_args()

signal.signal(signal.SIGINT, utils.existence_handler)
signal.signal(signal.SIGTERM, utils.existence_handler)

protocols.init_salt()

null_status = -1
normal_status = 0
insertion_status = 1

local_address = args.address
local_port = args.port

local_socket_file = "/tmp/remote-fcitx-vim-socket.{:}.{:}".format(socket.gethostname(), os.getuid())
if os.path.exists(local_socket_file):
    os.remove(local_socket_file)

def remote_process(local_address, local_port, message_pipe):
    """
    local_address - str, ip address
    local_port - int, port number
    message_pipe - multiprocessing.Pipe, read-only
    """

    signal.signal(signal.SIGINT, signal.SIG_IGN)
    signal.signal(signal.SIGTERM, utils.existence_handler)

    try:
        #server_socket = socket.create_server((local_address, local_port), backlog=1)
        server_socket = socket.socket()
        server_socket.bind((local_address, local_port))
        server_socket.listen(1)
        while True:
            session, _ = server_socket.accept()
            print("Remote machine connected.")
            session.setblocking(True)
            session_active = True

            with tempfile.NamedTemporaryFile(prefix="remote-fcitx-vim-conn-"):
                while utils.is_active(session):
                    message = None
                    while message_pipe.poll():
                        message = message_pipe.recv()
                    if message is not None:
                        print(str(message))
                        session.sendall(message)

                    time.sleep(0.1)
    except KeyboardInterrupt:
        if "session" in vars() and utils.is_active(session):
            session.shutdown(socket.SHUT_RDWR)
        server_socket.shutdown(socket.SHUT_RDWR)
        #print("Shutting down the remote socket...")

def local_process(socket_file, message_pipe):
    """
    socket_file - str, path to the socket_file
    message_pipe - multiprocessing.Connection, write-only
    """

    signal.signal(signal.SIGINT, signal.SIG_IGN)
    signal.signal(signal.SIGTERM, utils.existence_handler)

    try:
        daemon_socket = socket.socket(socket.AF_UNIX)
        daemon_socket.bind(socket_file)
        daemon_socket.listen()
        while True:
            session, _ = daemon_socket.accept()
            session.setblocking(True)

            message = session.recv(512)
            message = protocols.repack_message(message)
            message_pipe.send(message)

            time.sleep(0.1)
    except KeyboardInterrupt:
        if "session" in vars() and utils.is_active(session):
            session.shutdown(socket.SHUT_RDWR)
        daemon_socket.shutdown(socket.SHUT_RDWR)

try:
    receiver, sender = multiprocessing.Pipe(duplex=False)
    remote_process_instance = multiprocessing.Process(target=remote_process,
            args=(local_address, local_port, receiver))
    local_process_instance = multiprocessing.Process(target=local_process,
            args=(local_socket_file, sender))

    remote_process_instance.start()
    local_process_instance.start()

    remote_process_instance.join()
    local_process_instance.join()
except KeyboardInterrupt:
    local_process_instance.terminate()
    remote_process_instance.terminate()
    os.remove(local_socket_file)
    exit(0)
