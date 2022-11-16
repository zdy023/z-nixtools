#!/usr/bin/python3

import sys
import json
import struct
import subprocess

message_length = sys.stdin.buffer.read(4)
message_length = struct.unpack("=I", message_length)[0]
message = sys.stdin.buffer.read(message_length).decode("utf-8")
message_object = json.loads(message)

firefox_window_list = message_object["wlist"]
firefox_window_list.sort()

wmctrl = subprocess.run(["wmctrl", "-lx"], capture_output=True, text=True)
window_list = []
for l in wmctrl.stdout.splitlines():
    fields = l.split()
    if fields[2]=="Navigator.firefox":
        window_list.append(fields[0])
window_list.sort()

current_activity = subprocess.run( [ "qdbus"
                                   , "org.kde.ActivityManager"
                                   , "/ActivityManager/Activities"
                                   , "CurrentActivity"
                                   ]
                                 , capture_output=True
                                 , text=True
                                 )
current_activity = current_activity.stdout.strip()
#print(current_activity)

target_ff_wid = None
for wid, ff_wid in zip(window_list, firefox_window_list):
    xprop = subprocess.run( ["xprop", "-id", wid, "_KDE_NET_WM_ACTIVITIES"]
                          , capture_output=True
                          , text=True
                          )
    activity_id = xprop.stdout.strip().split()[2][1:-1]
    if activity_id==current_activity:
        target_ff_wid = ff_wid
        break

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
