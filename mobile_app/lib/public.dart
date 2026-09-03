import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppColors {
  static const bg = Color(0xFF10160F);
  static const card = Color(0xFF182319);
  static const cardBorder = Color(0xFF2A3A2A);
  static const text = Color(0xFFEEF2EA);
  static const textDim = Color(0xFF93A191);
  static const accent = Color(0xFF6FBF73);
  static const accentSoft = Color(0xFF3A4A37);
  static const blue = Color(0xFF6DB8E8);
  static const orange = Color(0xFFD98A5F);
  static const track = Color(0x8024302A);
  static const purple = Color(0xFF9B7EDB);
}

class card extends StatelessWidget {
  final Widget child;
  card({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: this.child,
    );
  }
}
