import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_dark.dart';
import 'app_color_scheme.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        extensions: [AppColorScheme.light],
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorsDark.background,
        primaryColor: AppColorsDark.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColorsDark.primary,
          brightness: Brightness.dark,
        ),
        extensions: [AppColorScheme.dark],
      );
}