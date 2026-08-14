import 'package:flutter/material.dart';
import 'package:wedo_flutter/domain/entities/app_locale.dart';

extension AppLocaleFlutterX on AppLocale {
  Locale get toFlutterLocale => Locale(code);
}
