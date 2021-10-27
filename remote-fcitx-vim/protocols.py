"""
Protocols for remote-fcitx-vim.
Author: David Chang
Last Revision: Aug 26, 2020
"""

import struct

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

    return "{:}: {:}".format(mode_code, file_path).encode()

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
        return message[:5]==(_normal_mode_code + ": ").encode()
    return False

def is_insertion_mode_message(message):
    """
    message - object

    return bool
    """

    if type(message) is bytes:
        return message[:5]==(_insertion_mode_code + ": ").encode()
    return False

def is_closed_mode_message(message):
    """
    message - object

    return bool
    """

    if type(message) is bytes:
        return message[:5]==(_closed_mode_code + ": ").encode()
    return False

def extract_file_name_from_mode_message(message):
    """
    message - bytes, message of the normal or insertion or closed mode

    return str as the extracted file name
    """

    return str(message[5:], encoding="utf-8")
