import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';

abstract class ThemeRepo {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
}
