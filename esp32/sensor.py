# sensor.py
from machine import ADC, Pin
import config

_adc = ADC(Pin(config.SOIL_SENSOR_ADC_PIN))
_adc.atten(ADC.ATTN_11DB)   # بازه‌ی کامل ولتاژ ورودی (0 تا ~3.3v)
_adc.width(ADC.WIDTH_12BIT)  # مقدار خام بین 0 تا 4095


def read_raw() -> int:
    return _adc.read()


def read_moisture_percent() -> float:
    """
    تبدیل مقدار خام ADC به درصد رطوبت بر اساس مقادیر کالیبره‌شده در config.
    عدد بازگشتی بین ۰ (خشک) تا ۱۰۰ (خیس) است.
    """
    raw = read_raw()
    dry, wet = config.SOIL_DRY_RAW, config.SOIL_WET_RAW
    # جلوگیری از تقسیم بر صفر در صورت اشتباه بودن کالیبراسیون
    if dry == wet:
        return 0.0

    pct = (dry - raw) * 100.0 / (dry - wet)
    # محدود کردن مقدار بین ۰ تا ۱۰۰
    return max(0.0, min(100.0, pct))
