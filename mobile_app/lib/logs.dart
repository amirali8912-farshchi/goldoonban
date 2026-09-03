import 'package:flutter/material.dart';
import 'public.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamsi_date/shamsi_date.dart';

String toShamsi(String date) {
  final dt = DateTime.parse(date).toLocal();
  final j = Jalali.fromDateTime(dt);

  return '${j.year}/${j.month.toString().padLeft(2, '0')}/${j.day.toString().padLeft(2, '0')}'
      ' - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class Logs extends StatefulWidget {
  @override
  State<Logs> createState() => _Logs();
}

class _Logs extends State<Logs> {
  // const Logs({super.key});
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Message> allmessages = [];
  List<Message> commands = [];
  List<Message> alerts = [];
  List<Message> reads = [];
  List thisalarm = [];
  @override
  void initState() {
    super.initState();
    getInitialSettings();
    thisalarm = allmessages;
    // checkSupabaseConnection();
  }

  Future<void> getInitialSettings() async {
    print('iuoqueoqiueio');
    try {
      final command = await supabase
          .from('command')
          .select()
          .eq('readed', true);
      print(command);
      final alert = await supabase.from('alerts').select();
      print(alert);
      // .eq('readed', true);
      final read = await supabase.from('reads').select();
      print(read);
      // .limit(1);
      setState(() {
        for (var i = 0; i < command.length; i++) {
          allmessages.add(
            Message(
              'command',
              'آبیاری',
              command[i]['created_at'].toString(),
              "ابیاری طبق دستور",
              command[i]['created_at'].toString(),
            ),
          );
          commands.add(
            Message(
              'command',
              'آبیاری',
              command[i]['created_at'].toString(),
              "ابیاری طبق دستور",
              command[i]['created_at'].toString(),
            ),
          );
        }

        for (var i = 0; i < alert.length; i++) {
          allmessages.add(
            Message(
              'alert',
              'هشدار',
              alert[i]['created_at'].toString(),
              "این یک هشدار میباشد",
              alert[i]['created_at'].toString(),
            ),
          );
          alerts.add(
            Message(
              'alert',
              'هشدار',
              alert[i]['created_at'].toString(),
              "این یک هشدار میباشد",
              alert[i]['created_at'].toString(),
            ),
          );
        }

        for (var i = 0; i < read.length; i++) {
          String howmany = read[i]['how_many'].toString();
          allmessages.add(
            Message(
              'read',
              'قرائت',
              read[i]['created_at'].toString(),
              "رطوبت هنگام خوانش $howmany",
              read[i]['created_at'].toString(),
            ),
          );
          reads.add(
            Message(
              'read',
              'قرائت',
              read[i]['created_at'].toString(),
              "رطوبت هنگام خوانش $howmany",
              read[i]['created_at'].toString(),
            ),
          );
        }
        // مرتب‌سازی و تبدیل reads
        reads.sort((a, b) {
          final dateA = DateTime.parse(a.time);
          final dateB = DateTime.parse(b.time);
          return dateB.compareTo(dateA);
        });

        for (var i = 0; i < reads.length; i++) {
          String timee = toShamsi(reads[i].time);
          reads[i].time = timee;
          print('asdasdlakd;sakdakdl;  $timee');
        }

        // مرتب‌سازی و تبدیل commands
        commands.sort((a, b) {
          final dateA = DateTime.parse(a.time);
          final dateB = DateTime.parse(b.time);
          return dateB.compareTo(dateA);
        });

        for (var i = 0; i < commands.length; i++) {
          print('lklk;lklklklkkl;;kl;lk;lklk;l;k;lkkl;;kl');
          String timee = toShamsi(commands[i].time);
          print('asdasdlakd;sakdakdl;  $timee');
          commands[i].time = timee;
        }

        // مرتب‌سازی و تبدیل alerts
        alerts.sort((a, b) {
          final dateA = DateTime.parse(a.time);
          final dateB = DateTime.parse(b.time);
          return dateB.compareTo(dateA);
        });

        for (var i = 0; i < alerts.length; i++) {
          alerts[i].time = toShamsi(alerts[i].time);
        }

        // مرتب‌سازی و تبدیل allmessages
        allmessages.sort((a, b) {
          final dateA = DateTime.parse(a.time);
          final dateB = DateTime.parse(b.time);
          return dateB.compareTo(dateA);
        });

        for (var i = 0; i < allmessages.length; i++) {
          allmessages[i].time = toShamsi(allmessages[i].time);
        }
        print(command);
        print(reads);
        print(alerts);

        // final
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error getting settings: $e');
    }
  }

  // Message returnany(type) {
  //   List types = {'reads': reads};
  //   for
  // }
  String getLastWeekCount(List<Message> messages) {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    return messages
        .where((message) {
          final date = DateTime.parse(message.supabase_time);
          return date.isAfter(oneWeekAgo) && date.isBefore(now);
        })
        .length
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 3.5;
    return Column(
      children: [
        Text('تاریخچه', style: TextStyle(fontSize: 30)),
        Container(
          margin: EdgeInsetsDirectional.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: size,

                // height: size,
                child: card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            getLastWeekCount(commands),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text('بار', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Text(
                        'آبیاری در این هفته',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size,

                // height: size,
                child: card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            getLastWeekCount(alerts),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text('بار', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Text('هشدار در این هفته', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
              Container(
                width: size,

                // height: size,
                child: card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            getLastWeekCount(reads),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text('بار', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                      Text('قرائت در این هفته', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: (() {
                setState(() {
                  thisalarm = allmessages;
                });
              }),
              child: Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0x782C2B2B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [Text('همه')]),
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  thisalarm = commands;
                });
              }),
              child: Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0x782C2B2B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [Text('آبیاری')]),
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  thisalarm = alerts;
                });
              }),
              child: Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0x782C2B2B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [Text('هشدار')]),
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  thisalarm = reads;
                });
              }),
              child: Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0x782C2B2B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [Text('قرائت')]),
              ),
            ),
          ],
        ),

        // for (var i = 0; i < reads.length; i++) {
        //   reads[i]
        // };
        ...thisalarm,
        SizedBox(height: 90),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final String type;
  final String title;
  final String supabase_time;
  String time;
  final String description;
  Message(
    this.type,
    this.title,
    this.time,
    this.description,
    this.supabase_time, {
    super.key,
  });
  final Map<String, List> anytypes = {
    'read': [AppColors.purple, Icons.sensors_rounded],
    'command': [AppColors.blue, Icons.water_drop],
    'alert': [AppColors.orange, Icons.warning_rounded],
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      margin: EdgeInsets.only(top: 9),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 37,
            height: 37,

            decoration: BoxDecoration(
              // color: Colors.white.withValues(alpha: .25),
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),

            child: Icon(
              // ,
              anytypes[type]![1],
              color: anytypes[type]![0],
              size: 20,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time),
                  ],
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    description,
                    style: TextStyle(color: AppColors.textDim, fontSize: 13),
                    // textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
