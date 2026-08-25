# time_sync.py
import time
import ntptime
import config


def sync(retries: int = 3) -> bool:
    ntptime.host = config.NTP_HOST
    for _ in range(retries):
        try:
            ntptime.settime()  # RTC را بر اساس UTC تنظیم می‌کند
            return True
        except Exception as e:
            print("[time_sync] تلاش ناموفق برای همگام‌سازی زمان:", e)
            time.sleep(2)
    return False


def local_time():
    """
    زمان محلی را بر اساس افست تعریف‌شده در config برمی‌گرداند.
    خروجی: (year, month, mday, hour, minute, second, weekday, yearday)
    """
    offset_seconds = int(config.TIMEZONE_OFFSET_HOURS * 3600)
    return time.localtime(time.time() + offset_seconds)
