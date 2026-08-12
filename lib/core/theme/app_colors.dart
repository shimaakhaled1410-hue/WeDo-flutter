import 'package:flutter/material.dart';

/// "Indigo Glow" theme — warm indigo primary with a vibrant coral accent.
/// A modern, energetic palette suited for task/notification-driven apps.
class AppColors {
  // ============ Brand Colors ============
  static const Color primary = Color(0xFF6C56F9);
  static const Color primaryDark = Color(0xFF4F3DD1);
  static const Color primaryLight = Color(0xFFEFEAFF);

  static const Color accent = Color(0xFFFF7A59);
  static const Color accentDark = Color(0xFFE85F3D);
  static const Color accentLight = Color(0xFFFFEDE7);

  // ============ Backgrounds & Surfaces ============
  static const Color background = Color(0xFFFAF9FC);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF5F3FA);

  // ============ Text ============
  static const Color textDark = Color(0xFF1A1523);
  static const Color textLight = Color(0xFF6E6880);
  static const Color textMuted = Color(0xFFA79FBD);
  static const Color white = Colors.white;

  // ============ Borders / Dividers ============
  static const Color border = Color(0xFFE8E4F3);
  static const Color divider = Color(0xFFF0EDF7);

  // ============ Status Colors ============
  static const Color success = Color(0xFF16B981);
  static const Color successLight = Color(0xFFE4F9F1);

  static const Color error = Color(0xFFF23D5C);
  static const Color errorLight = Color(0xFFFFE9ED);

  static const Color warning = Color(0xFFFFAB2E);
  static const Color warningLight = Color(0xFFFFF3E0);

  static const Color info = Color(0xFF4A9DFF);
  static const Color infoLight = Color(0xFFE9F3FF);

  // ============ Gradients ============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF9A7BFF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFFAE7A)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFB565E8), accent],
  );

  // ============ Shadows ============
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF6C56F9).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.10),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get accentShadow => [
        BoxShadow(
          color: accent.withValues(alpha: 0.20),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];
}