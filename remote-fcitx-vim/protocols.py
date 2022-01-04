"""
Protocols for remote-fcitx-vim.
Author: David Chang
Last Revision: Aug 26, 2020
"""

#import struct
import hashlib
import secrets

import functools
import math
import itertools
import operator

CHUNK_LENGTH = 512
_salt = secrets.token_bytes(CHUNK_LENGTH)

@functools.lru_cache(maxsize=256)
def get_hash(file_path):
    """
    file_path - str

    return bytes
    """

    file_path_bytes = file_path.encode("utf-8")
    salted_bytes = bytes(
            itertools.starmap(operator.xor,
                zip(file_path_bytes,
                    map(lambda ite: ite[1],
                        itertools.takewhile(lambda ite: ite[0]<len(file_path_bytes),
                            enumerate(itertools.cycle(_salt)))))))

    return hashlib.sha256(salted_bytes).digest()

activation_test_message = b'\0'
def is_activation_test_message(message):
    """
    message - object
    
    return bool
    """

    return message==activation_test_message

_normal_mode_code = "000"
_insertion_mode_code = "007"
_closed_mode_code = "063"

def _file_mode_message(mode_code, file_path):
    """
    mode_code - str, `_normal_mode_code` or `_insertion_mode_code` or `_closed_mode_code`
    file_path - str, file path

    return bytes
    """

    #return "{:}: {:}".format(mode_code, file_path).encode()
    file_path_hash = get_hash(file_path)
    return mode_code.encode("utf-8") + file_path_hash

def normal_mode_message(file_path):
    """
    file_path - str, file path"

    return bytes
    """

    return _file_mode_message(_normal_mode_code, file_path)

def insertion_mode_message(file_path):
    """
    file_path - str, file path"

    return bytes
    """

    return _file_mode_message(_insertion_mode_code, file_path)

def closed_mode_message(file_path):
    """
    file_path - str, file path"

    return bytes
    """

    return _file_mode_message(_closed_mode_code, file_path)

def is_normal_mode_message(message):
    """
    message - object

    return bool
    """

    if type(message) is bytes:
        return message[:5]==(_normal_mode_code + ": ").encode("utf-8")
    return False

def is_insertion_mode_message(message):
    """
    message - object

    return bool
    """

    if type(message) is bytes:
        return message[:5]==(_insertion_mode_code + ": ").encode("utf-8")
    return False

def is_closed_mode_message(message):
    """
    message - object

    return bool
    """

    if type(message) is bytes:
        return message[:5]==(_closed_mode_code + ": ").encode("utf-8")
    return False

def extract_file_name_from_mode_message(message):
    """
    message - bytes, message of the normal or insertion or closed mode

    return str as the extracted file name
    """

    return message[5:]
