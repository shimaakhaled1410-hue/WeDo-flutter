import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedo_flutter/domain/entities/app_locale.dart';

abstract class LocaleLocalDataSource {
  Future<AppLocale> getLocale();
  Future<void> setLocale(AppLocale locale);
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  static const _key = 'app_locale';

  @override
  Future<AppLocale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);

    return AppLocale.values.firstWhere(
      (locale) => locale.code == stored,
      orElse: () => AppLocale.english,
    );
  }

  @override
  Future<void> setLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.code);
  }
}