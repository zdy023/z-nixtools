import protocols

def existence_handler(signal_number, frame):
    """
    signal_number - int
    frame - frame
    """

    raise KeyboardInterrupt()

def is_active(session):
    """
    session - socket.socket

    return bool
    """

    try:
        session.sendall(protocols.activation_test_message)
        session.sendall(protocols.activation_test_message)
        return True
    except BrokenPipeError:
        return False
    except ConnectionError:
        return False
    except OSError:
        return False
