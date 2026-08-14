import 'package:flutter/material.dart';
import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';

extension AppThemeModeFlutterX on AppThemeMode {
  ThemeMode get toFlutterThemeMode => switch (this) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.system => ThemeMode.system,
  };
}
