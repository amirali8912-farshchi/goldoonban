# گلدون‌بان — فرم‌ور MicroPython برای ESP32

## ساختار فایل‌ها
```
config.py           تنظیمات وای‌فای، Supabase، پین‌ها و زمان‌بندی
wifi_manager.py      اتصال و مدیریت وای‌فای
time_sync.py         همگام‌سازی زمان با NTP (برای تشخیص ساعت آبیاری)
sensor.py             خواندن و کالیبراسیون سنسور رطوبت خاک
pump.py               کنترل رله پمپ آب
supabase_client.py    ارتباط با Supabase REST API (insert/select/update/log)
main.py                حلقه اصلی برنامه
```

## پیش‌نیازها روی دستگاه
1. فریم‌ور MicroPython روی ESP32 نصب شده باشد.
2. کتابخانه `urequests` باید روی دستگاه کپی شود (بخشی از micropython-lib است؛
   می‌توانید با `mip` نصب کنید یا فایل `urequests.py` را مستقیم در ریشه فلش کپی کنید):
   ```
   import mip
   mip.install("urequests")
   ```
   یا با ابزار `ampy` / `mpremote` فایل را دستی آپلود کنید.
3. `ntptime` معمولاً در فریم‌ور استاندارد ESP32 موجود است.

## استقرار
همه فایل‌های این پروژه (به‌جز README) را با `mpremote` یا `ampy` روی ریشه‌ی
فلش دستگاه کپی کنید، مقادیر `config.py` را با اطلاعات واقعی خودتان
(SSID، رمز وای‌فای، آدرس و کلید Supabase) پر کنید، سپس دستگاه را ریست کنید
تا `main.py` به‌صورت خودکار اجرا شود.

```
mpremote connect /dev/ttyUSB0 fs cp config.py wifi_manager.py time_sync.py sensor.py pump.py supabase_client.py main.py :
```

## ساختار پیشنهادی جداول Supabase

### sensor_readings
| ستون | نوع |
|---|---|
| id | bigint, primary key, identity |
| device_id | text |
| moisture_percent | float8 |
| raw_value | int4 |
| created_at | timestamptz, default now() |

### commands
| ستون | نوع |
|---|---|
| id | bigint, primary key, identity |
| device_id | text |
| command | text  — مقادیر مجاز: `water_now`, `pump_on`, `pump_off`, `reboot` |
| duration_seconds | int4, nullable — فقط برای `water_now` |
| executed | bool, default false |
| created_at | timestamptz, default now() |

### logs
| ستون | نوع |
|---|---|
| id | bigint, primary key, identity |
| device_id | text |
| action | text |
| status | text — مثلاً success / failed / error / warning / info / ok |
| message | text |
| created_at | timestamptz, default now() |

> توصیه می‌شود روی `device_id` در هر سه جدول ایندکس بگذارید و Row Level
> Security را برای هر جدول بر اساس نیاز خودتان تنظیم کنید.

## نکات مهم
- کالیبراسیون سنسور (`SOIL_DRY_RAW` و `SOIL_WET_RAW` در `config.py`) باید با
  آزمایش واقعی روی خاک خشک و خاک خیس‌شده تنظیم شود.
- منطق آبیاری زمان‌بندی‌شده در حال حاضر لوکال است (در `config.py`). اگر
  می‌خواهید زمان‌بندی از خود Supabase خوانده شود، می‌توان یک جدول
  `schedule` اضافه کرد و `task_scheduled_watering` را برای خواندن از آن
  جدول تغییر داد — در صورت نیاز بگو تا اضافه کنم.
- در صورت قطعی وای‌فای، `wifi_manager.ensure_connected()` در هر دور حلقه
  تلاش برای اتصال مجدد می‌کند.
