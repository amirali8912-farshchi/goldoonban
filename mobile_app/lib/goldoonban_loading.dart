// goldoonban_loading.dart
// انیمیشن لودینگ رنگی برای اپ گلدون‌بان
// یک گلدون + آب‌پاش که آب می‌ریزد و گیاه رشد می‌کند و شکوفه می‌زند — به‌صورت چرخه‌ای تکرار می‌شود.
//
// استفاده:
//   Scaffold(body: Center(child: GoldoonBanLoading()))
//
// نکته: کل ویجت داخل Directionality(LTR) قرار گرفته تا اگر اپ شما RTL باشد
// (که برای اپ فارسی طبیعی است)، چیدمان داخلی انیمیشن به‌هم نریزد.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoldoonBanLoading extends StatefulWidget {
  final double size;
  const GoldoonBanLoading({super.key, this.size = 280});

  @override
  State<GoldoonBanLoading> createState() => _GoldoonBanLoadingState();
}

class _GoldoonBanLoadingState extends State<GoldoonBanLoading>
    with TickerProviderStateMixin {
  late final AnimationController _cycle;
  late final AnimationController _dots;

  static const soil = Color(0xFF7A4E2D);
  static const soilDark = Color(0xFF5C3A21);
  static const pot = Color(0xFFE8834E);
  static const potDark = Color(0xFFC4652F);
  static const leaf1 = Color(0xFF4CAF6D);
  static const leaf2 = Color(0xFF8BD46E);
  static const leaf3 = Color(0xFF2E8B57);
  static const water = Color(0xFF4FC3E8);
  static const flower = Color(0xFFFF6B9D);

  @override
  void initState() {
    super.initState();
    _cycle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
    _dots = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _cycle.dispose();
    _dots.dispose();
    super.dispose();
  }

  double _stemGrowth(double t) {
    if (t < 0.15) return (t / 0.15).clamp(0.0, 1.0);
    if (t < 0.72) return 1.0;
    if (t < 0.92) return (1 - (t - 0.72) / 0.20).clamp(0.0, 1.0);
    return 0.0;
  }

  double _leafOpacity(double t, double appearAt) {
    final lt = t - appearAt;
    if (lt < 0) return 0.0;
    if (lt < 0.15) return (lt / 0.15).clamp(0.0, 1.0);
    if (lt < 0.55) return 1.0;
    if (lt < 0.70) return (1 - (lt - 0.55) / 0.15).clamp(0.0, 1.0);
    return 0.0;
  }

  double _budOpacity(double t) {
    if (t < 0.58) return 0.0;
    if (t < 0.70) return ((t - 0.58) / 0.12).clamp(0.0, 1.0);
    if (t < 0.85) return 1.0;
    if (t < 0.94) return (1 - (t - 0.85) / 0.09).clamp(0.0, 1.0);
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: s,
        height: s * 1.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: s,
              height: s * 0.95,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: s * 0.5,
                      height: s * 0.55,
                      child: AnimatedBuilder(
                        animation: _cycle,
                        builder: (context, _) {
                          final t = _cycle.value;
                          final growth = _stemGrowth(t);
                          final stemMaxH = s * 0.28;

                          return Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: s * 0.42,
                                  height: s * 0.16,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [pot, potDark],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(s * 0.02),
                                      topRight: Radius.circular(s * 0.02),
                                      bottomLeft: Radius.circular(s * 0.10),
                                      bottomRight: Radius.circular(s * 0.10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.14,
                                child: Container(
                                  width: s * 0.48,
                                  height: s * 0.05,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFF09B67), pot],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      s * 0.025,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.155,
                                child: Container(
                                  width: s * 0.36,
                                  height: s * 0.035,
                                  decoration: BoxDecoration(
                                    gradient: const RadialGradient(
                                      colors: [soil, soilDark],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      s * 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.17,
                                child: Container(
                                  width: s * 0.02,
                                  height: stemMaxH * growth,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [leaf3, leaf1],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      s * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.22,
                                left: s * 0.11,
                                child: Opacity(
                                  opacity: _leafOpacity(t, 0.20),
                                  child: _Leaf(
                                    size: s,
                                    color: leaf2,
                                    flip: true,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.29,
                                right: s * 0.11,
                                child: Opacity(
                                  opacity: _leafOpacity(t, 0.32),
                                  child: _Leaf(
                                    size: s,
                                    color: leaf1,
                                    flip: false,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.36,
                                left: s * 0.14,
                                child: Opacity(
                                  opacity: _leafOpacity(t, 0.42),
                                  child: _Leaf(
                                    size: s,
                                    color: leaf3,
                                    flip: true,
                                    small: true,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: s * 0.17 + stemMaxH - s * 0.03,
                                child: Opacity(
                                  opacity: _budOpacity(t),
                                  child: Transform.scale(
                                    scale:
                                        0.7 +
                                        0.3 * _budOpacity(t).clamp(0.0, 1.0),
                                    child: _Flower(size: s, color: flower),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ShaderMask(
                //   shaderCallback: (bounds) => const LinearGradient(
                //     colors: [leaf3, water, flower],
                //   ).createShader(bounds),
                //   child: const Text(
                //     'در حال آبیاری گیاه شما',
                //     textDirection: TextDirection.rtl,
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                // SizedBox(height: s * 0.03),
                AnimatedBuilder(
                  animation: _dots,
                  builder: (context, _) {
                    final colors = [leaf1, water, flower];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final delay = i * 0.15;
                        var t = (_dots.value - delay) % 1.0;
                        if (t < 0) t += 1.0;
                        double lift = 0;
                        double opacity = 0.5;
                        if (t < 0.3) {
                          lift = -7 * (t / 0.3);
                          opacity = 0.5 + 0.5 * (t / 0.3);
                        } else if (t < 0.6) {
                          lift = -7 * (1 - (t - 0.3) / 0.3);
                          opacity = 1.0;
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: s * 0.01),
                          child: Transform.translate(
                            offset: Offset(0, lift),
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                width: s * 0.025,
                                height: s * 0.025,
                                decoration: BoxDecoration(
                                  color: colors[i],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Flower extends StatelessWidget {
  final double size;
  final Color color;
  const _Flower({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    final s = size;
    final petalW = s * 0.045;
    final petalH = s * 0.075;
    final light = Color.lerp(color, Colors.white, 0.35)!;

    Widget petal(double angleDeg) {
      return Transform.rotate(
        angle: angleDeg * math.pi / 180,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: petalW,
            height: petalH,
            margin: EdgeInsets.only(top: petalH * 0.02),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [color, light],
              ),
              borderRadius: BorderRadius.circular(petalW),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.35), blurRadius: s * 0.01),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: petalH * 2,
      height: petalH * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // پنج گلبرگ چیده‌شده به شکل دایره
          for (final angle in [0, 72, 144, 216, 288]) petal(angle.toDouble()),
          // مرکز گل
          Container(
            width: s * 0.045,
            height: s * 0.045,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFEFB0), Color(0xFFFFC24B)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  final double size;
  final Color color;
  final bool flip;
  final bool small;
  const _Leaf({
    required this.size,
    required this.color,
    required this.flip,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = size;
    final w = small ? s * 0.09 : s * 0.13;
    final h = small ? s * 0.05 : s * 0.075;
    return Transform.flip(
      flipX: flip,
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(w),
            bottomRight: Radius.circular(w),
            bottomLeft: Radius.circular(w),
          ),
        ),
      ),
    );
  }
}
