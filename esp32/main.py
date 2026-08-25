# main.py
# برنامه اصلی گلدون‌بان روی ESP32
#
# وظایف:
#   ۱. قرائت دوره‌ای سنسور رطوبت و ثبت در Supabase
#   ۲. آبیاری بر اساس زمان‌بندی از پیش تعریف‌شده
#   ۳. بررسی دوره‌ای جدول دستورات (commands) و اجرای دستورات جدید
#   ۴. بررسی رطوبت هر یک ساعت و ثبت اعلان در صورت افت رطوبت
#
# در هر عمل، یک رکورد گزارش در جدول logs ثبت می‌شود.

import time
import machine

import config
import wifi_manager
import time_sync
import sensor
import pump
import supabase_client as sb


# ---------- متغیرهای وضعیت (برای زمان‌بندی غیربلاک‌کننده) ----------
_last_sensor_read = 0
_last_command_poll = 0
_last_moisture_check = 0
_last_watering_trigger_minute = None  # جلوگیری از اجرای تکراری در همان دقیقه


def now_ms():
    return time.ticks_ms()


def elapsed_s(last_ms):
    return time.ticks_diff(now_ms(), last_ms) / 1000


# ---------- ۱. قرائت سنسور و ثبت در پایگاه داده ----------
def task_read_and_log_sensor():
    try:
        raw = sensor.read_raw()
        moisture = sensor.read_moisture_percent()
        ok = sb.insert(config.TABLE_READINGS, {
            "device_id": config.DEVICE_ID,
            "moisture_percent": moisture,
            "raw_value": raw,
        })
        status = "success" if ok else "failed"
        sb.log_action("sensor_reading", status,
                       "moisture={:.1f}% raw={}".format(moisture, raw))
        print("[sensor] moisture={:.1f}% raw={} -> {}".format(moisture, raw, status))
    except Exception as e:
        sb.log_action("sensor_reading", "error", str(e))
        print("[sensor] خطا:", e)


# ---------- ۲. آبیاری زمان‌بندی‌شده ----------
def task_scheduled_watering():
    global _last_watering_trigger_minute

    lt = time_sync.local_time()
    hour, minute = lt[3], lt[4]
    key = "{:02d}:{:02d}".format(hour, minute)

    for sch_hour, sch_minute, duration in config.WATERING_SCHEDULE:
        if hour == sch_hour and minute == sch_minute and _last_watering_trigger_minute != key:
            _last_watering_trigger_minute = key
            run_watering(duration_s=duration, source="schedule")
            break


def run_watering(duration_s: int, source: str):
    """اجرای واقعی آبیاری + ثبت گزارش قبل و بعد از عملیات."""
    sb.log_action("watering_start", "info",
                   "source={} duration={}s".format(source, duration_s))
    print("[pump] شروع آبیاری ({}s) - منبع: {}".format(duration_s, source))
    try:
        pump.run_for(duration_s)
        sb.log_action("watering_end", "success",
                       "source={} duration={}s".format(source, duration_s))
        print("[pump] آبیاری با موفقیت پایان یافت")
    except Exception as e:
        pump.turn_off()  # اطمینان از خاموش شدن پمپ در صورت خطا
        sb.log_action("watering_end", "error", str(e))
        print("[pump] خطا در آبیاری:", e)


# ---------- ۳. بررسی و اجرای دستورات جدید ----------
def task_poll_commands():
    query = "device_id=eq.{}&executed=eq.false&order=created_at.asc".format(config.DEVICE_ID)
    commands = sb.select(config.TABLE_COMMANDS, query=query, limit=5)

    if not commands:
        return

    for cmd in commands:
        execute_command(cmd)


def execute_command(cmd: dict):
    cmd_id = cmd.get("id")
    action = cmd.get("command", "")
    print("[command] اجرای دستور:", action)

    try:
        if action == "water_now":
            duration = cmd.get("duration_seconds", 10)
            run_watering(duration_s=duration, source="manual_command")

        elif action == "pump_on":
            pump.turn_on()
            sb.log_action("command_pump_on", "success")

        elif action == "pump_off":
            pump.turn_off()
            sb.log_action("command_pump_off", "success")

        elif action == "reboot":
            sb.log_action("command_reboot", "success")
            _mark_command_executed(cmd_id)
            time.sleep(1)
            machine.reset()

        else:
            sb.log_action("command_unknown", "error", "action={}".format(action))
            print("[command] دستور ناشناخته:", action)

        _mark_command_executed(cmd_id)

    except Exception as e:
        sb.log_action("command_error", "error", "id={} err={}".format(cmd_id, e))
        print("[command] خطا در اجرای دستور:", e)


def _mark_command_executed(cmd_id):
    if cmd_id is None:
        return
    query = "id=eq.{}".format(cmd_id)
    sb.update(config.TABLE_COMMANDS, query, {"executed": True})


# ---------- ۴. بررسی رطوبت هر یک ساعت و اعلان ----------
def task_hourly_moisture_check():
    try:
        moisture = sensor.read_moisture_percent()
        if moisture < config.MOISTURE_LOW_THRESHOLD:
            sb.log_action(
                "moisture_alert", "warning",
                "moisture={:.1f}% زیر آستانه {}% است".format(
                    moisture, config.MOISTURE_LOW_THRESHOLD)
            )
            print("[alert] رطوبت پایین: {:.1f}%".format(moisture))
        else:
            sb.log_action(
                "moisture_check", "ok",
                "moisture={:.1f}%".format(moisture)
            )
            print("[check] رطوبت طبیعی: {:.1f}%".format(moisture))
    except Exception as e:
        sb.log_action("moisture_check", "error", str(e))
        print("[check] خطا:", e)


# ---------- راه‌اندازی اولیه ----------
def setup():
    print("[setup] اتصال به وای‌فای...")
    if not wifi_manager.connect():
        print("[setup] اتصال وای‌فای ناموفق بود؛ ادامه با تلاش مجدد در حلقه اصلی")

    print("[setup] همگام‌سازی زمان...")
    time_sync.sync()

    sb.log_action("boot", "success", "دستگاه راه‌اندازی شد")
    print("[setup] راه‌اندازی کامل شد")


# ---------- حلقه اصلی ----------
def main():
    global _last_sensor_read, _last_command_poll, _last_moisture_check

    setup()

    # تنظیم اولیه برای اجرای فوری اولین قرائت
    _last_sensor_read = -10**9
    _last_command_poll = -10**9
    _last_moisture_check = -10**9

    while True:
        wifi_manager.ensure_connected()

        if elapsed_s(_last_sensor_read) >= config.SENSOR_READ_INTERVAL:
            task_read_and_log_sensor()
            _last_sensor_read = now_ms()

        if elapsed_s(_last_command_poll) >= config.COMMAND_POLL_INTERVAL:
            task_poll_commands()
            _last_command_poll = now_ms()

        if elapsed_s(_last_moisture_check) >= config.MOISTURE_CHECK_INTERVAL:
            task_hourly_moisture_check()
            _last_moisture_check = now_ms()

        # بررسی زمان‌بندی آبیاری هر بار (چون فقط بر اساس دقیقه‌ی فعلی تصمیم می‌گیرد)
        task_scheduled_watering()

        time.sleep(2)


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        sb.log_action("fatal_error", "error", str(e))
        print("[main] خطای بحرانی:", e)
        time.sleep(5)
        machine.reset()
