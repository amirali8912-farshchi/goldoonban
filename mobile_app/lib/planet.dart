import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ویجت نمایش گلدان با گیج سطح آب و موج متحرک.
///
/// [waterLevel] عددی بین 0.0 (خالی) تا 1.0 (پر) که ارتفاع تقریبی آب
/// داخل گلدان را مشخص می‌کند.
class PlantWaterGauge extends StatefulWidget {
  /// سطح آب، بین 0.0 و 1.0
  final double waterLevel;

  /// عرض کلی ویجت (ارتفاع بر اساس نسبت طرح اصلی محاسبه می‌شود)
  final double width;

  /// رنگ خط دور گلدان
  final Color potOutlineColor;

  /// رنگ خاک (پس‌زمینه‌ی بالای سطح آب داخل گلدان)
  final Color soilColor;

  /// رنگ آب
  final Color waterColor;

  /// رنگ خطوط ریشه
  final Color rootColor;

  /// آیا موج به‌صورت متحرک نمایش داده شود
  final bool animateWave;

  const PlantWaterGauge({
    super.key,
    required this.waterLevel,
    this.width = 224,
    this.potOutlineColor = const Color(0xFFB9663D),
    this.soilColor = const Color(0xFF6B4A32),
    this.waterColor = const Color(0xFF7EC8E3),
    this.rootColor = const Color(0xFF3F2E20),
    this.animateWave = true,
  });

  @override
  State<PlantWaterGauge> createState() => _PlantWaterGaugeState();
}

class _PlantWaterGaugeState extends State<PlantWaterGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.animateWave) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PlantWaterGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateWave && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animateWave && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double potViewW = 224;
    const double potViewH = 250;
    const double stemViewH = 70;

    final double scale = widget.width / potViewW;
    final double potHeight = potViewH * scale;
    final double stemHeight = stemViewH * scale;

    // مقدار هم‌پوشانی ساقه با لبه‌ی گلدان
    final double overlap = 20 * scale;

    final double totalHeight = potHeight + stemHeight - overlap;

    return SizedBox(
      width: widget.width,
      height: totalHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PlantGaugePainter(
              waterLevel: widget.waterLevel.clamp(0.0, 1.0),
              scale: scale,
              stemHeight: stemHeight,
              overlap: overlap,
              potOutlineColor: widget.potOutlineColor,
              soilColor: widget.soilColor,
              waterColor: widget.waterColor,
              rootColor: widget.rootColor,
              wavePhase: _controller.value * 2 * math.pi,
            ),
          );
        },
      ),
    );
  }
}

class _PlantGaugePainter extends CustomPainter {
  final double waterLevel;
  final double scale;
  final double stemHeight;
  final double overlap;
  final Color potOutlineColor;
  final Color soilColor;
  final Color waterColor;
  final Color rootColor;
  final double wavePhase;

  _PlantGaugePainter({
    required this.waterLevel,
    required this.scale,
    required this.stemHeight,
    required this.overlap,
    required this.potOutlineColor,
    required this.soilColor,
    required this.waterColor,
    required this.rootColor,
    required this.wavePhase,
  });

  // نقطه‌ی اتصال ریشه/ساقه در مختصات محلی گلدان (زیر لبه‌ی دهانه)
  static const double _anchorX = 112;
  static const double _anchorY = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final double potTop = stemHeight - overlap;

    canvas.save();
    canvas.translate(0, potTop);
    _paintPot(canvas);
    canvas.restore();

    // ساقه طوری جابه‌جا می‌شود که نقطه‌ی پایینش دقیقاً روی نقطه‌ی
    // شروع ریشه (بالای خاک) بنشیند، تا دو بخش به‌هم چسبیده دیده شوند.
    const double stemBaseX = 55; // در مختصات خودِ ساقه (viewBox 110x70)
    const double stemBaseY = 68;
    final double dx = (_anchorX * scale) - (stemBaseX * scale);
    final double dy = (potTop + _anchorY * scale) - (stemBaseY * scale);

    canvas.save();
    canvas.translate(dx, dy);
    _paintStem(canvas);
    canvas.restore();
  }

  // ---------------- گلدان ----------------

  Path _potOutlinePath() {
    final path = Path();
    path.moveTo(33 * scale, 8 * scale);
    path.quadraticBezierTo(33 * scale, 0, 41 * scale, 0);
    path.lineTo(183 * scale, 0);
    path.quadraticBezierTo(191 * scale, 0, 191 * scale, 8 * scale);
    path.lineTo(168 * scale, 232 * scale);
    path.quadraticBezierTo(166 * scale, 250 * scale, 148 * scale, 250 * scale);
    path.lineTo(76 * scale, 250 * scale);
    path.quadraticBezierTo(58 * scale, 250 * scale, 56 * scale, 232 * scale);
    path.close();
    return path;
  }

  void _paintPot(Canvas canvas) {
    final outline = _potOutlinePath();
    final bounds = outline.getBounds();

    canvas.save();
    canvas.clipPath(outline);

    // خاک: پس‌زمینه‌ی داخل گلدان (به‌جای سفید)
    final soilPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.lerp(soilColor, Colors.black, 0.15)!, soilColor],
      ).createShader(bounds);
    canvas.drawRect(bounds, soilPaint);

    // بافت ساده‌ی خاک: چند نقطه‌ی تیره‌ی تصادفی‌نما
    final texturePaint = Paint()..color = Colors.black.withValues(alpha: 0.12);
    final rnd = math.Random(7);
    for (int i = 0; i < 40; i++) {
      final double tx = bounds.left + rnd.nextDouble() * bounds.width;
      final double ty = bounds.top + rnd.nextDouble() * bounds.height;
      canvas.drawCircle(Offset(tx, ty), 1.2 * scale, texturePaint);
    }

    // ریشه‌ها (روی خاک، زیر آب هم دیده می‌شوند)
    _paintRoots(canvas);

    // سطح آب متحرک
    final double waterTopY = bounds.bottom - (bounds.height * waterLevel);
    final waterPaint = Paint()..color = waterColor;

    if (waterLevel > 0) {
      final wavePath = Path();
      const double waveHeight = 3.5;
      final double waveLength = bounds.width / 1.4;

      wavePath.moveTo(bounds.left, waterTopY);
      double x = bounds.left;
      while (x <= bounds.right + waveLength) {
        final double y =
            waterTopY +
            math.sin((x / waveLength) * 2 * math.pi + wavePhase) *
                waveHeight *
                scale;
        wavePath.lineTo(x, y);
        x += 4;
      }
      wavePath.lineTo(bounds.right, bounds.bottom);
      wavePath.lineTo(bounds.left, bounds.bottom);
      wavePath.close();
      canvas.drawPath(wavePath, waterPaint);

      // یک لایه‌ی نور نازک روی سطح آب برای حس براقیت
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * scale;
      final highlightPath = Path();
      x = bounds.left;
      bool first = true;
      while (x <= bounds.right) {
        final double y =
            waterTopY +
            math.sin((x / waveLength) * 2 * math.pi + wavePhase) *
                waveHeight *
                scale;
        if (first) {
          highlightPath.moveTo(x, y);
          first = false;
        } else {
          highlightPath.lineTo(x, y);
        }
        x += 4;
      }
      canvas.drawPath(highlightPath, highlightPaint);
    }

    canvas.restore();

    // خط دور گلدان
    final outlinePaint = Paint()
      ..color = potOutlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawPath(outline, outlinePaint);

    // لبه‌ی بیضی‌شکل دهانه‌ی گلدان
    final rimPaint = Paint()
      ..color = potOutlineColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(112 * scale, 3 * scale),
        width: 158 * scale,
        height: 14 * scale,
      ),
      rimPaint,
    );
  }

  void _paintRoots(Canvas canvas) {
    final rootPaint = Paint()
      ..color = rootColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;

    final start = Offset(_anchorX * scale, _anchorY * scale);

    final r1 = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        108 * scale,
        40 * scale,
        96 * scale,
        55 * scale,
        78 * scale,
        70 * scale,
      );
    final r2 = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        116 * scale,
        44 * scale,
        128 * scale,
        58 * scale,
        148 * scale,
        76 * scale,
      );
    final r3 = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        110 * scale,
        60 * scale,
        112 * scale,
        90 * scale,
        100 * scale,
        120 * scale,
      );

    canvas.drawPath(r1, rootPaint);
    canvas.drawPath(r2, rootPaint);
    canvas.drawPath(r3, rootPaint);
  }

  // ---------------- ساقه و برگ‌ها ----------------
  // این متد با فرض این‌که canvas از قبل به نقطه‌ی اتصال جابه‌جا شده صدا زده می‌شود.

  void _paintStem(Canvas canvas) {
    final stemPaintDark = Paint()
      ..color = const Color(0xFF4B7047)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    final stemPaintMid = Paint()
      ..color = const Color(0xFF5C8C57)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;

    Path stemCurve(
      double x1,
      double y1,
      double cx1,
      double cy1,
      double cx2,
      double cy2,
      double x2,
      double y2,
    ) {
      return Path()
        ..moveTo(x1 * scale, y1 * scale)
        ..cubicTo(
          cx1 * scale,
          cy1 * scale,
          cx2 * scale,
          cy2 * scale,
          x2 * scale,
          y2 * scale,
        );
    }

    canvas.drawPath(stemCurve(55, 68, 53, 46, 40, 40, 26, 24), stemPaintDark);
    canvas.drawPath(stemCurve(55, 68, 57, 44, 70, 36, 86, 20), stemPaintDark);
    canvas.drawPath(stemCurve(55, 68, 54, 50, 55, 42, 55, 30), stemPaintMid);

    _drawRotatedLeaf(
      canvas,
      cx: 24,
      cy: 20,
      rx: 15,
      ry: 9,
      color: const Color(0xFF5C8C57),
      rotationDeg: -28,
    );
    _drawRotatedLeaf(
      canvas,
      cx: 88,
      cy: 16,
      rx: 16,
      ry: 9.5,
      color: const Color(0xFF6A9D62),
      rotationDeg: 24,
    );
    _drawRotatedLeaf(
      canvas,
      cx: 55,
      cy: 26,
      rx: 11,
      ry: 15,
      color: const Color(0xFF7FAE72),
      rotationDeg: 0,
    );
  }

  void _drawRotatedLeaf(
    Canvas canvas, {
    required double cx,
    required double cy,
    required double rx,
    required double ry,
    required Color color,
    required double rotationDeg,
  }) {
    canvas.save();
    canvas.translate(cx * scale, cy * scale);
    canvas.rotate(rotationDeg * math.pi / 180);
    final paint = Paint()..color = color;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: rx * 2 * scale,
        height: ry * 2 * scale,
      ),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PlantGaugePainter oldDelegate) {
    return oldDelegate.waterLevel != waterLevel ||
        oldDelegate.wavePhase != wavePhase ||
        oldDelegate.soilColor != soilColor ||
        oldDelegate.waterColor != waterColor;
  }
}
