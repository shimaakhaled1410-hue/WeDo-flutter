import 'package:flutter/material.dart';

class AppColorsDark {
  static const Color primary = Color(0xFF8B78FF);
  static const Color primaryLight = Color(0xFF2A2340);

  static const Color accent = Color(0xFFFF8A6B);
  static const Color accentLight = Color(0xFF3A2620);

  static const Color background = Color(0xFF121016);
  static const Color surface = Color(0xFF1C1926);
  static const Color surfaceMuted = Color(0xFF252132);

  static const Color textDark = Color(0xFFF3F1F8);
  static const Color textLight = Color(0xFFA9A2BC);
  static const Color textMuted = Color(0xFF6E6880);
  static const Color white = Colors.white;

  static const Color border = Color(0xFF322C42);
  static const Color divider = Color(0xFF2A2536);

  static const Color success = Color(0xFF2ED88F);
  static const Color successLight = Color(0xFF163024);

  static const Color error = Color(0xFFFF5C77);
  static const Color errorLight = Color(0xFF35181E);

  static const Color warning = Color(0xFFFFB648);
  static const Color warningLight = Color(0xFF332512);

  static const Color info = Color(0xFF5EA8FF);
  static const Color infoLight = Color(0xFF162A3D);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFB18CFF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFFB48A)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFFC97BE8), accent],
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get accentShadow => [
    BoxShadow(
      color: accent.withValues(alpha: 0.3),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];
}
