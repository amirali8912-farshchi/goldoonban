from machine import ADC, Pin
import time
from supabase import *
#from goldoonban import *

sensorvoltage=Pin(32,Pin.OUT)
sensor = ADC(Pin(34))
sensor.atten(ADC.ATTN_11DB)

pomp=Pin(4,Pin.OUT)

DRY_VALUE = 4095   # هوا (خشک‌ترین حالت)
WET_VALUE = 1088   # آب خالص (خیس‌ترین حالت)

def irragate(irragation):
    pomp.on()
    time.sleep(irragation)
    pomp.off()
    send_bale_message("آبياري با موفقيت انجام شد")


def read_moisture_percent(max_damp):
    sensorvoltage.on()
    time.sleep(2)
    raw = sensor.read()
    print(f'sensor :{raw}')
    time.sleep(2)
    sensorvoltage.off()
    percent = (DRY_VALUE - raw) * 100 / (DRY_VALUE - WET_VALUE)
    percent = max(0, min(100, percent))
    send_bale_message(f"رطوبت گلدان {round(percent, 1)}% ميباشد")
    if round(percent, 1)<=max_damp:
        #print(warning)
        send_to_supabase({
            "how_many": round(percent, 1)
        },'alerts')
        send_bale_message("اين يک هشدار رطوبت ميباشد وضعيت رطوب گلدان به حد بحراني رسيده است")
    return round(percent, 1)
 