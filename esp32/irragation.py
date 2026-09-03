from public import *
def handle(irragation,max_damp,damp):
    pass
def automatical(irragation,max_damp,damp):
    if float(damp)>=float(max_damp):
        irragate(irragation)
        send_to_supabase({
            "readed": 'TRUE'
        },'command')
def timeical(irragation,maxx,damp):
    days=["د","س","چ","پ","ج","ش","ي"]
    now =time.localtime()
    data=[maxx.split('__^^__')[0].split('-'),maxx.split('__^^__')[1].split('|')]
    print(data)
    print('now')
    print(now)
    
    for i in data[0]:
       # print('irragated0')
        if days[now[6]]==i:
            print('irragated1')
            for u in data[1]:
                print(u.split(':'))
                if int(u.split(':')[0])==now[3]:
                    print('irragated3')
                    if int(timemaker(u.split(':')[1]))==now[4]:
                        irragate(irragation)
                        send_to_supabase({
                            "readed": 'TRUE'
                        },'command')
                        
                        print('irragated')
    print(data)
    
def timemaker(x):
    if x[0]=='0':
        return x[1]
    else:
        return x