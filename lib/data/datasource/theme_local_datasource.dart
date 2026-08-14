import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';

abstract class ThemeLocalDataSource {
  Future<AppThemeMode> getThemeMode();
  Future<void> setThemeMode(AppThemeMode mode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const _key = 'app_theme_mode';

  @override
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);

    // Defaults to "system" the very first time — respects the phone's setting.
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => AppThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}