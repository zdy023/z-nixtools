#!/usr/bin/python3

import sys
import json
import struct

message_length = sys.stdin.buffer.read(4)
message_length = struct.unpack("=I", message_length)[0]
message = sys.stdin.buffer.read(message_length).decode("utf-8")
message_object = json.loads(message)

response_object = message_object
response = json.dumps(response_object).encode("utf-8")
response_length = len(response)
response_length = struct.pack("=I", response_length)
sys.stdout.buffer.write(response_length)
sys.stdout.buffer.write(response)
sys.stdout.buffer.flush()
