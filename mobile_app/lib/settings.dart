import 'package:flutter/material.dart';
import 'main.dart';
import 'home.dart';
import 'public.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goldoonban_loading.dart';

// به‌جای Enum، فقط از یه متن ساده استفاده می‌کنیم
// مقدار _mode می‌تونه یکی از این سه‌تا باشه: 'scheduled' یا 'humidity' یا 'manual'

class ScheduledTime {
  int hour;
  int minute;
  ScheduledTime(this.hour, this.minute);
  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

class SettingsScreen extends StatefulWidget {
  String connectionStatus = 'disconnected';
  double damp;
  SettingsScreen({
    super.key,
    required this.connectionStatus,
    required this.damp,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic>? settings;
  // String connectionStatus = 'disconnected';
  // double _humidityThreshold = 25;
  List<String> typedictionary = ["manual", "humidity", "scheduled"];
  int _durationSeconds = 45;
  String _mode = "humidity";
  bool isOn = true;
  double settingsmaxindampertype = 25.0;
  // ش ی د س چ پ ج  -> index 0..6, default: شنبه، دوشنبه، چهارشنبه فعال
  List<bool> _weekdays = [false, false, false, false, false, false, false];
  final List<String> _weekdayLabels = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
  List<ScheduledTime> _times = [];
  Future<void> loadSetting() async {
    final result = await DataBase.getSettings();
    setState(() {
      settings = result;
      _mode = typedictionary[result?['type']];
      // print(result?['max'].split('__^^__'));
      isOn = result?['warning'];
      // print(result?['max'].split('__^^__')[1].split('|'));
      _durationSeconds = result?['irrigation'];
      print(['س', 'د', "ی"].contains('ی'));
      if (result?['type'] == 2) {
        _weekdays = _weekdayLabels.map((item) {
          print(result?["max"].split('__^^__')[0].split('-'));
          print(_weekdayLabels[_weekdayLabels.indexOf(item)]);
          if (result?["max"]
              .split('__^^__')[0]
              .split('-')
              .contains(_weekdayLabels[_weekdayLabels.indexOf(item)])) {
            print(_weekdays);
            return true;
          } else {
            print(_weekdays);
            return false;
          }
        }).toList();
        // result?['max'].split('__^^__')[0].split('-').map((item) {
        //   return ;
        // });
        _times = result?['max']
            .split('__^^__')[1]
            .split('|')
            // .where((item) {
            //   item.length > 2;
            // })
            .map<ScheduledTime>((item) {
              print(item.length);

              return ScheduledTime(
                int.parse(item.split(':')[0]),
                int.parse(item.split(':')[1]),
              );
            })
            .toList();
        print(_times);
        print(_weekdays);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('بارگزاری شد')));
      } else if (result?['type'] == 1) {
        print('object');
        settingsmaxindampertype = double.parse(result?['max']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('بارگزاری شد')));
      }
    });
  }

  Future<void> _openAddTimeSheet() async {
    int selHour = 7;
    int selMinute = 15;

    final result = await showModalBottomSheet<ScheduledTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder),
                  left: BorderSide(color: AppColors.cardBorder),

                  right: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14, top: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const Text(
                    'افزودن ساعت آبیاری',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 44,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _wheel(
                              itemCount: 24,
                              initial: selHour,
                              onChanged: (v) => selHour = v,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                ':',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _wheel(
                              itemCount: 60,
                              initial: selMinute,
                              onChanged: (v) => selMinute = v,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: AppColors.textDim,
                            side: const BorderSide(color: AppColors.cardBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'لغو',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              ScheduledTime(selHour, selMinute),
                            );
                            DataBase.updateSettings(
                              max: [
                                _weekdayLabels
                                    .where(
                                      (item) =>
                                          _weekdays[_weekdayLabels.indexOf(
                                            item,
                                          )],
                                    )
                                    .join('-'),
                                [
                                  _times.map((time) => time.label).join('|'),
                                  ScheduledTime(selHour, selMinute).label,
                                ].join('|'),
                              ].join('__^^__'),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.accent,
                            foregroundColor: const Color(0xFF0D180D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'افزودن',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => _times.add(result));
    }
  }

  Widget _wheel({
    required int itemCount,
    required int initial,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 70,
      height: 160,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 44,
        diameterRatio: 1.3,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: initial),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSetting();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? page = {
      'checking': GoldoonBanLoading(),
      'disconnected': Home(damp: widget.damp),
      'connected': _build(),
    };
    print(widget.connectionStatus);
    return page[widget.connectionStatus];
  }

  Widget _build() {
    return Column(
      children: [
        Text('تنظیمات', style: TextStyle(fontSize: 30)),
        _humidityCard(),
        const SizedBox(height: 16),
        _pumpCard(),
        const SizedBox(height: 20),
        _advanced(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _humidityCard() {
    // var bottom = CustomSwitch(width: 36, height: 22);
    double width = 36;
    double height = 22;
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'آستانه‌ی هشدار رطوبت خاک',
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.accentSoft,
                child: Text('💧', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const Text(
            'اگر رطوبت خاک از این مقدار کمتر شود، برایت هشدار می‌ فرستیم.',
            style: TextStyle(color: AppColors.textDim, fontSize: 12.5),
          ),
          _divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هشدار افت رطوبت',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ارسال هشدار در صورت کم شدن رطوبت',
                    style: TextStyle(color: AppColors.textDim, fontSize: 11.5),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOn = !isOn;
                    DataBase.updateSettings(warning: isOn ? 1 : 0);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(' ذخیره شد ')));
                  });
                },
                child: Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.symmetric(
                    vertical: width / 18,
                    horizontal: width / 40,
                  ),
                  decoration: BoxDecoration(
                    color: isOn
                        ? const Color(0xFF61965F)
                        : const Color(0xFF555555),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    alignment: isOn
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: (width / 5) * 3,
                      height: (width / 5) * 3,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: isOn
                ? Column(
                    children: [
                      _divider(),
                      const SizedBox(height: 12),
                      sweeper(value: settings?["max_damp"] ?? 25.0, ontap: 1),
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _pumpCard() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'رفتار پمپ آب',
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.accentSoft,
                child: Text('⚙️', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'مشخص کن پمپ چطور و کِی فعال شود.',
            style: TextStyle(color: AppColors.textDim, fontSize: 12.5),
          ),
          const SizedBox(height: 14),
          _segmentedControl(),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _modeContent(),
          ),
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    // این تابع سه‌تا دکمه می‌سازه: هر دکمه یه مقدار متنی داره (مثل 'scheduled')
    // وقتی روش کلیک بشه، _mode همون مقدار می‌شه
    Widget seg(String value, String emoji, String label) {
      final active = _mode == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() {
            _mode = value;
            DataBase.updateSettings(type: typedictionary.indexOf(value));
            print(typedictionary.indexOf(value));
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: active ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: active ? const Color(0xFF0D180D) : AppColors.textDim,
                    fontWeight: active ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF101A10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          seg('scheduled', '🕐', 'زمان‌ بندی‌ شده'),
          seg('humidity', '💧', 'براساس رطوبت'),
          seg('manual', '✋', 'دستی'),
        ],
      ),
    );
  }

  // بسته به مقدار _mode، محتوای مناسب رو نشون می‌ده
  Widget _modeContent() {
    if (_mode == 'scheduled') {
      return _scheduledContent(key: const ValueKey('scheduled'));
    } else if (_mode == 'humidity') {
      return _humidityModeContent(key: const ValueKey('humidity'));
    } else {
      return _manualContent(key: const ValueKey('manual'));
    }
  }

  Widget _divider() => Container(
    height: 1,
    color: AppColors.cardBorder,
    margin: const EdgeInsets.symmetric(vertical: 12),
  );

  Widget _durationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مدت هر آبیاری',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'زمان روشن‌ بودن پمپ',
              style: TextStyle(color: AppColors.textDim, fontSize: 11.5),
            ),
          ],
        ),
        Row(
          children: [
            _stepBtn('−', () {
              setState(() {
                _durationSeconds -= 5;
                DataBase.updateSettings(irrigation: _durationSeconds);
              });
            }),
            SizedBox(
              width: 64,
              child: Text(
                '$_durationSeconds ثانیه',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _stepBtn(
              '+',
              () => setState(() {
                _durationSeconds += 5;
                DataBase.updateSettings(irrigation: _durationSeconds);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF101A10),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.text, fontSize: 16),
        ),
      ),
    );
  }

  Widget _scheduledContent({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ساعت‌ های آبیاری',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < _times.length; i++) _timeChip(i),
            GestureDetector(
              // onTap: () {
              //   _openAddTimeSheet();
              // },
              onTap: _openAddTimeSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.accentSoft),
                ),
                child: const Text(
                  '+ افزودن ساعت',
                  style: TextStyle(color: AppColors.accent, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
        _divider(),
        const Text(
          'روزهای هفته',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'آبیاری فقط در روزهای انتخاب‌ شده انجام می‌ شود',
          style: TextStyle(color: AppColors.textDim, fontSize: 11.5),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < 7; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _weekdays[i] = !_weekdays[i];
                    DataBase.updateSettings(
                      max: [
                        _weekdayLabels
                            .where(
                              (item) => _weekdays[_weekdayLabels.indexOf(item)],
                            )
                            .join('-'),
                        _times.map((time) => time.label).join('|'),
                      ].join('__^^__'),
                    );
                  }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _weekdays[i]
                          ? AppColors.accent
                          : const Color(0xFF101A10),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _weekdays[i]
                            ? AppColors.accent
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Text(
                      _weekdayLabels[i],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _weekdays[i]
                            ? const Color(0xFF0D180D)
                            : AppColors.textDim,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _divider(),
        _durationRow(),
      ],
    );
  }

  Widget _timeChip(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF101A10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _times[index].label,
            style: const TextStyle(color: AppColors.text, fontSize: 13),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => setState(() => _times.removeAt(index)),
            child: const Text(
              '✕',
              style: TextStyle(color: AppColors.textDim, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _humidityModeContent({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _durationRow(),
        _divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آستانه‌ی فعال‌ سازی  ',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // Text(
            //   'همان آستانه‌ی رطوبت بالای صفحه استفاده می‌ شود',
            //   style: TextStyle(color: AppColors.textDim, fontSize: 11.5),
            // ),
            SizedBox(
              // width: 480,
              child: sweeper(
                value: settingsmaxindampertype,
                fontSize: 20,
                ontap: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _lowdamp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هشدار افت رطوبت',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'زمانی که رطوبت از مقدار معینی پایین برود برای شما اعلان هشدار ارسال خواهد شد',
              style: TextStyle(color: AppColors.textDim, fontSize: 11.5),
            ),
          ],
        ),

        // CustomSwitch(width: 36, height: 22),
      ],
    );
  }

  Widget _manualContent({Key? key}) {
    return Column(key: key, children: [_durationRow()]);
  }
}

class sweeper extends StatefulWidget {
  double value;
  double fontSize = 30;
  int ontap;
  sweeper({
    super.key,
    required this.value,
    this.fontSize = 30,
    required this.ontap,
  });
  @override
  State<sweeper> createState() => _sweeperState();
}

class _sweeperState extends State<sweeper> {
  @override
  Widget build(BuildContext context) {
    List properties = [
      () => DataBase.updateSettings(max: widget.value.toString()),
      () => DataBase.updateSettings(maxDamp: widget.value),
      // () => print(widget.value.toString()),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            '${widget.value.round()}٪',
            style: TextStyle(
              color: AppColors.blue,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Slider(
          value: widget.value,
          min: 0,
          max: 100,

          activeColor: AppColors.blue,
          onChanged: (v) {
            setState(() {
              widget.value = v;
              properties[widget.ontap]();
            });
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '۰٪',
              style: TextStyle(color: AppColors.textDim, fontSize: 11),
            ),
            Text(
              '۵۰٪',
              style: TextStyle(color: AppColors.textDim, fontSize: 11),
            ),
            Text(
              '۱۰۰٪٪',
              style: TextStyle(color: AppColors.textDim, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

// class CustomSwitch extends StatefulWidget {
//   double width;
//   double height;
//   bool isOn;
//   CustomSwitch({
//     super.key,
//     required this.width,
//     required this.height,
//     this.isOn = true,
//   });
//   // void changestatus(bool status) {
//   //   setState(() {
//   //     isOn = status;
//   //   });
//   // }

//   bool status() {
//     return isOn;
//   }

//   @override
//   State<CustomSwitch> createState() => _CustomSwitchState();
// }

// class _CustomSwitchState extends State<CustomSwitch> {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class _advanced extends StatefulWidget {
  @override
  State<_advanced> createState() => __advanced();
}

class __advanced extends State<_advanced> {
  bool suggested = false;
  @override
  Widget build(BuildContext context) {
    return card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'پیشرفته',
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    suggested = suggested ? false : true;
                    print(suggested);
                  });
                },
                icon: Icon(
                  suggested
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: suggested ? advancedwidget() : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class advancedwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PotNameInput(variable: 'supabase_url'),
        SizedBox(height: 9),
        PotNameInput(variable: 'supabase_anonkey'),
      ],
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
