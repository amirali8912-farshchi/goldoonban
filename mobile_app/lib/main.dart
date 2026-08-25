import 'goldoonban_loading.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'logs.dart';
import 'settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'public.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://gemjqpdiyneddmugprqg.supabase.co/",
    anonKey: "sb_publishable_76fsDhbBNO7D3f4SI-eCwQ_-mzjSaFG",
  );
  runApp(GoldoonbanApp());
  // runApp(PlantWaterGaugeDemo);
}

class GoldoonbanApp extends StatefulWidget {
  const GoldoonbanApp({super.key});

  @override
  State<GoldoonbanApp> createState() => _GoldoonbanApp();
}

class _GoldoonbanApp extends State<GoldoonbanApp> {
  // final GoldoonbanApp({super.key});
  final supabase = Supabase.instance.client;

  double moisture = 22;
  int? irrigationType;
  double? alertThreshold;
  String? schedule;

  bool isLoading = true;
  String connectionStatus = 'disconnected';
  @override
  void initState() {
    super.initState();
    getInitialSettings();
    checkSupabaseConnection();
  }

  Future<void> checkSupabaseConnection() async {
    // setState(() {
    connectionStatus = 'checking';
    // });

    try {
      await DataBase.getSettings();
      // setState(() {
      connectionStatus = 'connected';
      // });
    } catch (e) {
      // setState(() {
      connectionStatus = 'disconnected';
      // });
    }
  }

  Future<void> getInitialSettings() async {
    try {
      final data = await supabase.from('settings').select().limit(1).single();

      setState(() {
        moisture = (data['damp'] as num).toDouble();
        irrigationType = data['type'] as int?;
        alertThreshold = (data['max_damp'] as num?)?.toDouble();
        schedule = data['max'] as String?;

        isLoading = false;
      });

      print(data);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error getting settings: $e');
    }
  }

  int nowpage = 2;
  @override
  Widget build(BuildContext context) {
    var pages = [
      SettingsScreen(connectionStatus: connectionStatus, damp: moisture),
      Home(damp: moisture),
      Logs(),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa'),
      title: 'گلدون‌بان',
      theme: ThemeData(
        fontFamily: 'Vazirmatn',
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.text),
          bodyMedium: TextStyle(color: AppColors.text),
          bodySmall: TextStyle(color: AppColors.text),
        ),
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.bg,
          selectedItemColor: AppColors.orange,
          // unselectedIconTheme: IconThemeData(color: ),
          unselectedItemColor: AppColors.text,
          // selectedIconTheme: IconThemeData(color: ),
          // fixedColor: AppColors.text,
          currentIndex: nowpage,
          onTap: (index) => setState(() {
            nowpage = index;
          }),
          items: [
            BottomNavigationBarItem(
              backgroundColor: AppColors.textDim,
              icon: Icon(Icons.settings),
              label: 'تنظیمات',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'لاگ'),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            children: [
              // Text('رطوبت: $moisture'),
              // Text('نوع آبیاری: $irrigationType'),
              // Text('آستانه هشدار: $alertThreshold'),
              // Text('زمان‌بندی: $schedule'),
              Expanded(child: SingleChildScrollView(child: pages[nowpage])),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         setState(() {
              //           nowpage = 0;
              //         });
              //       },
              //       child: Column(
              //         // style:,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(Icons.bar_chart, color: Colors.white60, size: 30),
              //           SizedBox(height: 2),
              //           Text("گزارش", style: TextStyle(color: Colors.white60)),
              //         ],
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {
              //         print(9 / 2);
              //         setState(() {
              //           nowpage = 1;
              //         });
              //       },
              //       child: Column(
              //         // style:,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(Icons.home, color: Colors.white60, size: 30),
              //           SizedBox(height: 2),
              //           Text("خانه", style: TextStyle(color: Colors.white60)),
              //         ],
              //       ),
              //     ),

              //     InkWell(
              //       onTap: () {
              //         setState(() {
              //           nowpage = 2;
              //         });
              //       },
              //       child: Column(
              //         // style:,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(Icons.settings, color: Colors.white60, size: 30),
              //           SizedBox(height: 2),
              //           Text(
              //             "تنظیمات",
              //             style: TextStyle(color: Colors.white60),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class database {
  final supabase = Supabase.instance.client;
  Future<void> updateSettings({
    double? damp,
    int? type,
    double? maxDamp,
    String? max,
    int? warning,
    int? irrigation,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (damp != null) {
        updates['damp'] = damp;
      }

      if (type != null) {
        print(type);
        updates['type'] = type;
      }

      if (maxDamp != null) {
        updates['max_damp'] = maxDamp;
      }

      if (max != null) {
        updates['max'] = max;
      }

      if (warning != null) {
        updates['warning'] = warning == 1;
      }

      if (irrigation != null) {
        updates['irrigation'] = irrigation;
      }

      if (updates.isEmpty) return;

      await supabase.from('settings').update(updates).eq('id', 0);

      print('Settings updated');
    } catch (e) {
      print('Error updating settings: $e');
    }
  }

  String connectionStatus = 'disconnected';
  String getstatus() {
    return connectionStatus;
  }

  Future<void> checkSupabaseConnection() async {
    connectionStatus = 'checking';

    try {
      await DataBase.getSettings();

      connectionStatus = 'connected';
    } catch (e) {
      connectionStatus = 'disconnected';
    }
  }

  // await checkSupabaseConnection();
  // Future<void> getstatus() async {}

  Future<Map<String, dynamic>?> getSettings() async {
    try {
      final data = await supabase
          .from('settings')
          .select()
          .eq('id', 0)
          .maybeSingle();

      print('Settings: $data');

      return data;
    } catch (e) {
      print('Error getting settings: $e');
      return null;
    }
  }
}

database DataBase = database();
