import 'package:fl_chart/fl_chart.dart';
import 'main.dart';
import 'planet.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'public.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({super.key});

  final List<String> labels = const ['شنبه', 'یک', 'دو', 'سه', 'چهار', 'پنج'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            // برچسب‌های بالا و راست رو خاموش می‌کنیم
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }
                  // یه چک اضافه برای اطمینان از اینکه فقط اعداد صحیح رو نشون بده
                  if (value != value.toInt()) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            // مقدار عددی کنار محور Y (اختیاری)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 4),
                FlSpot(4, 3.5),
                FlSpot(5, 5),
              ],
              isCurved: true,
              color: const Color(0xFF3B82F6),
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterButton extends StatelessWidget {
  final String title;
  final String countdown;
  final VoidCallback onTap;

  const WaterButton({
    super.key,
    required this.title,
    required this.countdown,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        height: 90,

        margin: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: const Color(0xff5C9CC2),
          borderRadius: BorderRadius.circular(25),

          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withValues(alpha: .15),
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            const SizedBox(width: 20),

            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .25),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.water_drop,
                color: Colors.white,
                size: 35,
              ),
            ),

            const SizedBox(width: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  countdown,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final double damp;
  Home({super.key, required this.damp});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  // Future<void> loadSetting() async {
  //   final result = await getSettings();
  //   setState(() {
  //   });
  // }
  String difference = '0.00';
  String connectionStatus = 'disconnected';
  void initState() {
    // TODO: implement initState
    super.initState();
    difrentcommand();
    // loadSetting();
    // checkSupabaseConnection();
  }

  Future<void> difrentcommand() async {
    final data = await Supabase.instance.client
        .from('command')
        .select('created_at')
        .eq('readed', true)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data != null) {
      final createdAt = DateTime.parse(data['created_at']);
      final now = DateTime.now();
      setState(() {
        difference = (now.difference(createdAt).inHours / 24).toStringAsFixed(
          2,
        );

        print(difference);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double damp = widget.damp;
    return Column(
      children: [
        Text('صفحه اصلی', style: TextStyle(fontSize: 30)),
        // Row(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(5),
        //       decoration: BoxDecoration(
        //         color: connectionStatus == 'connected'
        //             ? Colors.green
        //             : connectionStatus == 'disconnected'
        //             ? Colors.brown
        //             : Color(0xFF7A4530),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Column(
        //         children: [
        //           connectionStatus == 'connected'
        //               ? Text("متصل")
        //               : connectionStatus == 'disconnected'
        //               ? Text("قطع")
        //               : Text("درحال بررسی"),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        Stack(
          children: [
            // Positioned.fill(child: child)
            Center(child: PlantWaterGauge(waterLevel: damp / 100, width: 200)),
            Center(
              widthFactor: double.infinity,
              heightFactor: 6,
              child: Text(
                '$damp%',
                // style: TextStyle(fontSize: 35, color: Color(value)),
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFFFFF8F0),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text('آخرین آبیاری $difference روز پیش'),
        ),
        card(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(' ۷ روز گذشته'), Text('روند رطوبت خاک')],
              ),
              SizedBox(height: 16),
              MyLineChart(),
            ],
          ),
        ),
        WaterButton(
          title: "آبیاری بعدی",
          countdown: "02:35:20 باقی مانده",
          onTap: () async {
            await Supabase.instance.client.from('command').insert({
              "readed": false,
            });
          },
        ),
      ],
    );
  }
}
