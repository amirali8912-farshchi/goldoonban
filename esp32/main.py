import network
import time
from irragation import handle,automatical,timeical
from supabase import *
from public import *


def connect_wifi(ssid, password):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    
    if not wlan.isconnected():
        print("در حال اتصال به Wi-Fi...")
        wlan.connect(ssid, password)
        
        timeout = 15
        start = time.time()
        while not wlan.isconnected():
            if time.time() - start > timeout:
                print("اتصال ناموفق بود!")
                return None
            time.sleep(0.5)
    
    print("متصل شد! آی‌پی:", wlan.ifconfig()[0])
    return wlan

#wlan = connect_wifi("Amirali", "21316516")
wlan=connect_wifi("Farshci","9141164315")
#wlan=connect_wifi("Farshchi","sanam@1374")
import time
#print(read_commands("command","readed=eq.FALSE&select=*"))
last_run=time.time()
warning=True
def warning1():
    return warning
# استفاده
def main():
    #Pin(4,Pin.OUT).off()
    send_bale_message("برق آمد")

    data=read_commands("settings","select=*")
    print('data')
    print(data)
    boot = Pin(0, Pin.IN, Pin.PULL_UP)
    typeoflists=[handle,automatical,timeical]
    typee=int(data[0]["type"])
    maxx=data[0]["max"]
    max_damp=data[0]["max_damp"]
    warning=data[0]["warning"]
    irrigation1=data[0]["irrigation"]
    print(typee,maxx,max_damp,warning,irrigation1)
    moisture = read_moisture_percent(max_damp)
    send_to_supabase({
            "how_many": moisture
        },'reads')
    update_command_status(0,{
            "damp": moisture
        },'settings')
    
    
    
    
    
    while True:
        print('''booted










''',boot.value())
        if boot.value() == 0:
            print("BOOT زده شد!")
            break

        time.sleep(1800)
        typeoflists[typee](irrigation1,maxx,moisture)
        commands=read_commands("command","readed=eq.FALSE&select=*")
#    if len(commands) != 0:
        for i in commands:
            irragate(irrigation1)
            print(i)
            print('command')
            update_command_status(i["id"],{
                "readed": 'TRUE'
            },'command')
        if time.time() - last_run>=43200:
            moisture = read_moisture_percent(max_damp)
            send_to_supabase({
                    "how_many": moisture
                },'reads')
            update_command_status(0,{
                    "damp": moisture
                },'settings')
            data=read_commands("settings","select=*")
            typee=data[0]["type"]
            maxx=data[0]["max"]
            max_damp=data[0]["max_damp"]
            warning=data[0]["warning"]
            irrigation=data[0]["irrigation"]
            print(typee,maxx,max_damp,warning.irrigation)
            


main()