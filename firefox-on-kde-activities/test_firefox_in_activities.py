#!/usr/bin/python3

import sys
import json
import struct
import subprocess
import multiprocessing
import time

from pathlib import Path
#from typing import TextIO
import logging
import os

import signal

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

debug_handler = logging.FileHandler(os.path.join(os.path.dirname(__file__), "local.log"))
debug_handler.setLevel(logging.DEBUG)
formatter = logging.Formatter(fmt="\x1b[1;33m[%(asctime)s \x1b[31m%(name)s/%(levelname)s \x1b[32m%(module)s/%(lineno)d-%(processName)s\x1b[1;33m] \x1b[0m%(message)s")
debug_handler.setFormatter(formatter)
logger.addHandler(debug_handler)
logger = logging.getLogger("main")

aid_file = Path("~/.cache/kde-activities-z/aid").expanduser()
aid_file.parent.mkdir(parents=True, exist_ok=True)

def _get_current_activity():
    #  function _get_current_activity {{{ # 
    current_activity: subprocess.CompletedProcess =\
            subprocess.run( [ "qdbus"
                            , "org.kde.ActivityManager"
                            , "/ActivityManager/Activities"
                            , "CurrentActivity"
                            ]
                          , capture_output=True
                          , text=True
                          )
    current_activity: str = current_activity.stdout.strip()
    logger.debug("KDE CHANGE ACT: {:}".format(current_activity))

    aid_file.write_text(current_activity)
    #  }}} function _get_current_activity # 

def _watch_current_activity():
    #  function _check_current_activity {{{ # 
    activity_change_watcher = subprocess.Popen(
                                [ "dbus-monitor"
                                , "--session"
                                , "--monitor"
                                , "type='signal',interface='org.kde.ActivityManager.Activities',member='CurrentActivityChanged'"
                                ]
                              , bufsize=0
                              , stdout=subprocess.PIPE
                              , text=True
                              )
    for l in activity_change_watcher.stdout:
        if l.strip().endswith("CurrentActivityChanged"):
            _get_current_activity()
    #  }}} function _check_current_activity # 

_get_current_activity()
activity_change_watcher = multiprocessing.Process(target=_watch_current_activity)
activity_change_watcher.start()

def _exit_handler(singnal_number: int, frame):
    activity_change_watcher.kill()
signal.signal(signal.SIGTERM, _exit_handler)

while True:
    message_length = sys.stdin.buffer.read(4)
    message_length = struct.unpack("=I", message_length)[0]
    message = sys.stdin.buffer.read(message_length).decode("utf-8")
    message_object = json.loads(message)

    firefox_window_list = message_object["wlist"]
    firefox_window_list.sort()

    logger.info("FF WLIST: {:}".format(str(firefox_window_list)))

    wmctrl = subprocess.run(["wmctrl", "-lx"], capture_output=True, text=True)
    window_list = []
    for l in wmctrl.stdout.splitlines():
        fields = l.split()
        if fields[2]=="Navigator.firefox":
            window_list.append(fields[0])
    window_list.sort()

    logger.info("KDE WLIST: {:}".format(str(window_list)))

    current_activity: str = aid_file.read_text()
    logger.info("KDE CURRENT ACT: %s", current_activity)

    target_ff_wid = None
    for wid, ff_wid in zip(window_list, firefox_window_list):
        xprop = subprocess.run( ["xprop", "-id", wid, "_KDE_NET_WM_ACTIVITIES"]
                              , capture_output=True
                              , text=True
                              )
        activity_id = xprop.stdout.strip().split()[2][1:-1]
        logger.info("WIN ACT: {:} {:} {:}".format(wid, ff_wid, activity_id))
        if activity_id==current_activity:
            target_ff_wid = ff_wid
            break

    logger.info("TAR FF WIN: {:}".format(target_ff_wid))
    #log_file.flush()

    if target_ff_wid is None:
        response_object = { "act": "new"
                          , "tid": message_object["tid"]
                          }
    elif target_ff_wid!=message_object["wid"]:
        response_object = { "act": "move"
                          , "tid": message_object["tid"]
                          , "wid": target_ff_wid
                          }
    else:
        response_object = {"act": "none"}

    response = json.dumps(response_object).encode("utf-8")
    response_length = len(response)
    response_length = struct.pack("=I", response_length)
    sys.stdout.buffer.write(response_length)
    sys.stdout.buffer.write(response)
    sys.stdout.buffer.flush()


    #time.sleep(3.)
    #subprocess.run( [ "qdbus"
                    #, "org.kde.ActivityManager"
                    #, "/ActivityManager/Activities"
                    #, "SetCurrentActivity"
                    #, current_activity
                    #]
                  #)
