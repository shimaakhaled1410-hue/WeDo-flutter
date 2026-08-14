import 'package:flutter/material.dart';
import 'package:wedo_flutter/l10n/app_localizations.dart';

extension LocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
