import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logs.dart';
import 'settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'public.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final supabaseUrl = prefs.getString('supabase_url');
  final supabaseKey = prefs.getString('supabase_anonkey');
  print('$supabaseUrl $supabaseKey');
  if (supabaseUrl != null && supabaseKey != null) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    runApp(GoldoonbanApp());
  } else {
    runApp(advancedwidget());
  }
}

class advancedwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        // color: AppColors.bg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'این صفحه به این معنا میباشد که شما تاکنون از این اپلیکیشن در این سیستم استفاده ننموده اید برای استفاده ابتدا توضیحات را در صفحه گیت هاب مشاهده نمایید',
            ),
            PotNameInput(variable: 'supabase_url'),
            SizedBox(height: 9),
            PotNameInput(variable: 'supabase_anonkey'),
          ],
        ),
      ),
    );
  }
}

class PotNameInput extends StatefulWidget {
  final String variable;
  const PotNameInput({super.key, required this.variable});

  @override
  State<PotNameInput> createState() => _PotNameInputState(variable);
}

class _PotNameInputState extends State<PotNameInput> {
  final String variable;
  _PotNameInputState(this.variable);
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadName();
  }

  // خواندن مقدار ذخیره‌شده
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      controller.text = prefs.getString('$variable') ?? '';
    });
  }

  // ذخیره مقدار
  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('$variable', controller.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$variable ذخیره شد ')));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            cursorColor: AppColors.accent,
            decoration: InputDecoration(
              hintText: '$variable را وارد کنید',
              hintStyle: TextStyle(color: AppColors.text),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.accent, width: 1.5),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 50,
          height: 50,
          child: ElevatedButton(
            onPressed: saveName,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.accent),

              foregroundColor: WidgetStatePropertyAll(AppColors.bg),

              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),

              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            ),

            child: const Icon(Icons.check_rounded, size: 30),
          ),
        ),
      ],
    );
  }
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

  final List<_NavItemData> _items = const [
    _NavItemData(icon: Icons.settings, label: "تنظیمات"),
    _NavItemData(icon: Icons.home, label: "خانه"),
    _NavItemData(icon: Icons.bar_chart, label: "گزارش"),
  ];
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

  Widget _buildPillNavBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10.0, 10, 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.9),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final bool selected = index == nowpage;
          return GestureDetector(
            onTap: () => setState(() => nowpage = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, color: Colors.white),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
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

  int nowpage = 1;
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                // Text('رطوبت: $moisture')              // Text('نوع آبیاری: $irrigationType'),
                // Text('آستانه هشدار: $alertThreshold'),
                // Text('زمان‌بندی: $schedule'),
                // (
                // child: SingleChildScrollView(child: pages[nowpage]),
                // ),
                SingleChildScrollView(child: pages[nowpage]),
                SizedBox(height: 29),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildPillNavBar()),
                ),
                SizedBox(height: 9),
              ],
            ),
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

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}
