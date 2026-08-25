# pump.py
from machine import Pin
import time
import config

_relay = Pin(config.PUMP_RELAY_PIN, Pin.OUT)


def _set(state_on: bool):
    if config.PUMP_ACTIVE_HIGH:
        _relay.value(1 if state_on else 0)
    else:
        _relay.value(0 if state_on else 1)


def is_on() -> bool:
    val = _relay.value()
    return (val == 1) if config.PUMP_ACTIVE_HIGH else (val == 0)


def turn_on():
    _set(True)


def turn_off():
    _set(False)


def run_for(seconds: int):
    """پمپ را برای مدت مشخص روشن و سپس خاموش می‌کند (بلاک‌کننده)."""
    turn_on()
    time.sleep(seconds)
    turn_off()
