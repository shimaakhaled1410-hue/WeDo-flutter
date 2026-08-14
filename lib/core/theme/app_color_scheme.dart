import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_dark.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.primary,
    required this.primaryLight,
    required this.accent,
    required this.accentLight,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.textDark,
    required this.textLight,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.success,
    required this.successLight,
    required this.error,
    required this.errorLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.primaryGradient,
    required this.accentGradient,
    required this.heroGradient,
    required this.cardShadow,
    required this.softShadow,
    required this.accentShadow,
  });

  final Color primary;
  final Color primaryLight;
  final Color accent;
  final Color accentLight;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color textDark;
  final Color textLight;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color success;
  final Color successLight;
  final Color error;
  final Color errorLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;
  final Gradient primaryGradient;
  final Gradient accentGradient;
  final Gradient heroGradient;
  final List<BoxShadow> cardShadow;
  final List<BoxShadow> softShadow;
  final List<BoxShadow> accentShadow;

  static final light = AppColorScheme(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    accent: AppColors.accent,
    accentLight: AppColors.accentLight,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceMuted: AppColors.surfaceMuted,
    textDark: AppColors.textDark,
    textLight: AppColors.textLight,
    textMuted: AppColors.textMuted,
    border: AppColors.border,
    divider: AppColors.divider,
    success: AppColors.success,
    successLight: AppColors.successLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    info: AppColors.info,
    infoLight: AppColors.infoLight,
    primaryGradient: AppColors.primaryGradient,
    accentGradient: AppColors.accentGradient,
    heroGradient: AppColors.heroGradient,
    cardShadow: AppColors.cardShadow,
    softShadow: AppColors.softShadow,
    accentShadow: AppColors.accentShadow,
  );

  static final dark = AppColorScheme(
    primary: AppColorsDark.primary,
    primaryLight: AppColorsDark.primaryLight,
    accent: AppColorsDark.accent,
    accentLight: AppColorsDark.accentLight,
    background: AppColorsDark.background,
    surface: AppColorsDark.surface,
    surfaceMuted: AppColorsDark.surfaceMuted,
    textDark: AppColorsDark.textDark,
    textLight: AppColorsDark.textLight,
    textMuted: AppColorsDark.textMuted,
    border: AppColorsDark.border,
    divider: AppColorsDark.divider,
    success: AppColorsDark.success,
    successLight: AppColorsDark.successLight,
    error: AppColorsDark.error,
    errorLight: AppColorsDark.errorLight,
    warning: AppColorsDark.warning,
    warningLight: AppColorsDark.warningLight,
    info: AppColorsDark.info,
    infoLight: AppColorsDark.infoLight,
    primaryGradient: AppColorsDark.primaryGradient,
    accentGradient: AppColorsDark.accentGradient,
    heroGradient: AppColorsDark.heroGradient,
    cardShadow: AppColorsDark.cardShadow,
    softShadow: AppColorsDark.softShadow,
    accentShadow: AppColorsDark.accentShadow,
  );

  @override
  AppColorScheme copyWith() => this;

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppColorSchemeX on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;
}