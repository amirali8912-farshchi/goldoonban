import urequests
import ujson
import socket
import ssl
#from goldoonban import warning

SUPABASE_URL = "https://gemjqpdiyneddmugprqg.supabase.co/"

SUPABASE_KEY = "sb_publishable_76fsDhbBNO7D3f4SI-eCwQ_-mzjSaFG"  # anon key از تنظیمات پروژه
# = "reads"  # اسم جدولی که ساختی
CHAT_ID="693934507"
BOT_TOKEN="662713737:yGcnEuWZDjwq5NTedp9EiX4JR2O2O50kW0U"

def send_bale_message(text):
    warning=read_commands("settings","id=eq.0&select=warning")[0]["warning"]
    print(warning)
    if warning:
    #from goldoonban import warning1
    #print(warning1)
    #print('warning')
        body = '{"chat_id":"' + str(CHAT_ID) + '","text":"' + str(text) + '"}'
    
        host = "tapi.bale.ai"
    
        addr = socket.getaddrinfo(host, 443)[0][-1]
    
        sock = socket.socket()
        sock.connect(addr)
    
        sock = ssl.wrap_socket(sock, server_hostname=host)
        request = (
            "POST /bot" + BOT_TOKEN + "/sendMessage HTTP/1.1\r\n"
            "Host: " + host + "\r\n"
            "Content-Type: application/json\r\n"
            "Content-Length: " + str(len(body.encode("utf-8"))) + "\r\n"
            "Connection: close\r\n"
            "\r\n"
            + body
        )
        
        sock.write(request.encode("utf-8"))
        
        response = sock.read()
        print(response.decode())
        
        sock.close()
    else:
        pass

    
def read_commands(table,condantion):
    url = f"{SUPABASE_URL}/rest/v1/{table}?{condantion}"
    
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}"
    }
    
    try:
        response = urequests.get(url, headers=headers)
        data = response.json()
        response.close()
        return data
    except Exception as e:
        print("خطا در خوندن:", e)
        return None
   
def send_to_supabase(data,TABLE_NAME):
    url = f"{SUPABASE_URL}/rest/v1/{TABLE_NAME}"
    
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=minimal"  # جواب کامل نمی‌خوایم، فقط تایید
    }
    
#    data = 
    
    try:
        response = urequests.post(url, headers=headers, data=ujson.dumps(data))
        print("وضعیت ارسال:", response.status_code)
        print(response.text)
        response.close()  # حتماً ببندش، وگرنه حافظه پر می‌شه
        return response.status_code == 201
    except Exception as e:
        print("خطا در ارسال:", e)
        return False
def update_command_status(command_id, data,tablename):
    url = f"{SUPABASE_URL}/rest/v1/{tablename}?id=eq.{command_id}"
    
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=minimal"
    }
    
    
    try:
        response = urequests.patch(url, headers=headers, data=ujson.dumps(data))
        print("وضعیت آپدیت:", response.status_code)
        response.close()
    except Exception as e:
        print("خطا در آپدیت:", e)
