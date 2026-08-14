import 'package:wedo_flutter/domain/entities/app_locale.dart';

abstract class LocaleRepo {
  Future<AppLocale> getLocale();
  Future<void> setLocale(AppLocale locale);
}