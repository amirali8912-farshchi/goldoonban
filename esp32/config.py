# config.py
# تمام مقادیر قابل‌تغییر پروژه اینجا نگه‌داری می‌شود تا در سایر ماژول‌ها
# نیازی به هاردکد کردن نباشد.

# ---------- Wi-Fi ----------
WIFI_SSID = "Farshci"
WIFI_PASSWORD = "9141164315"

# ---------- Supabase ----------
SUPABASE_URL = "https://gemjqpdiyneddmugprqg.supabase.co/"
# ترجیحاً از service_role key فقط در محیط امن (نه در کلاینت عمومی) استفاده شود.
SUPABASE_KEY = "sb_publishable_76fsDhbBNO7D3f4SI-eCwQ_-mzjSaFG"

# نام جدول‌ها در Supabase (در صورت نیاز تغییر بده)
TABLE_READINGS = "sensor_readings"     # ثبت قرائت سنسورها
TABLE_COMMANDS = "commands"            # دستورات ارسالی از اپ/سرور
TABLE_LOGS = "logs"                    # گزارش هر عملیات (رویدادنگاری)

# شناسه یکتای این دستگاه (برای فیلتر کردن رکوردها در Supabase)
DEVICE_ID = "goldoonban-01"

# ---------- پین‌ها ----------
SOIL_SENSOR_ADC_PIN = 34   # پین آنالوگ سنسور رطوبت خاک
PUMP_RELAY_PIN = 26        # پین رله کنترل پمپ آب
PUMP_ACTIVE_HIGH = True    # اگر رله با HIGH فعال می‌شود True، در غیر این صورت False

# ---------- کالیبراسیون سنسور رطوبت ----------
# مقدار خام ADC در خاک کاملاً خشک و کاملاً خیس (باید با آزمایش واقعی تنظیم شود)
SOIL_DRY_RAW = 4095
SOIL_WET_RAW = 1500

# ---------- زمان‌بندی آبیاری ----------
# هر آیتم: (ساعت, دقیقه, مدت آبیاری به ثانیه)
WATERING_SCHEDULE = [
    (7, 0, 10),
    (19, 0, 10),
]

# ---------- بازه‌های زمانی (ثانیه) ----------
SENSOR_READ_INTERVAL = 5 * 60        # هر ۵ دقیقه قرائت و ثبت سنسور
COMMAND_POLL_INTERVAL = 30           # هر ۳۰ ثانیه بررسی دستورات جدید
MOISTURE_CHECK_INTERVAL = 60 * 60    # هر ۱ ساعت بررسی رطوبت و اعلان
MOISTURE_LOW_THRESHOLD = 30          # درصد رطوبت؛ زیر این مقدار هشدار ثبت می‌شود

# ---------- NTP ----------
NTP_HOST = "pool.ntp.org"
TIMEZONE_OFFSET_HOURS = 3.5  # افست ایران نسبت به UTC
