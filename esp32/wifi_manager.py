# wifi_manager.py
import network
import time
import config


def connect(timeout_s: int = 20) -> bool:
    """اتصال به وای‌فای؛ در صورت موفقیت True برمی‌گرداند."""
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)

    if wlan.isconnected():
        return True

    wlan.connect(config.WIFI_SSID, config.WIFI_PASSWORD)

    start = time.ticks_ms()
    while not wlan.isconnected():
        if time.ticks_diff(time.ticks_ms(), start) > timeout_s * 1000:
            return False
        time.sleep_ms(200)

    return True


def is_connected() -> bool:
    return network.WLAN(network.STA_IF).isconnected()


def ensure_connected():
    """اگر اتصال قطع بود، تلاش برای اتصال مجدد."""
    if not is_connected():
        connect()
