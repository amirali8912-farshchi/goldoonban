import 'package:flutter/material.dart';
import 'public.dart';

class Logs extends StatelessWidget {
  const Logs({super.key});

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
                          Text('6', style: TextStyle(fontSize: 18)),
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
                          Text('6', style: TextStyle(fontSize: 18)),
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
                          Text('6', style: TextStyle(fontSize: 18)),
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
            ],
          ),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: (() {
                print('object');
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
                print('object');
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
                print('object');
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
                print('object');
              }),
              child: Container(
                margin: EdgeInsets.only(right: 9),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0x782C2B2B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [Text('قرایت')]),
              ),
            ),
          ],
        ),
        Message(
          'water',
          'آبیاری خودکار',
          '8:00 1405/6/7',
          '25 میلی لیتر طبق دستور',
        ),
        Message(
          'water',
          'آبیاری خودکار',
          '8:00 1405/6/7',
          '25 میلی لیتر طبق دستور',
        ),
        Message(
          'water',
          'آبیاری خودکار',
          '8:00 1405/6/7',
          '25 میلی لیتر طبق دستور',
        ),
        Message(
          'water',
          'آبیاری خودکار',
          '8:00 1405/6/7',
          '25 میلی لیتر طبق دستور',
        ),
        Message(
          'water',
          'آبیاری خودکار',
          '8:00 1405/6/7',
          '25 میلی لیتر طبق دستور',
        ),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final String type;
  final String title;
  final String time;
  final String description;
  const Message(
    this.type,
    this.title,
    this.time,
    this.description, {
    super.key,
  });

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

            child: const Icon(
              Icons.water_drop,
              color: AppColors.blue,
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
