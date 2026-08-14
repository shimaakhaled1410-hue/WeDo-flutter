enum AppLocale { english, arabic }

extension AppLocaleCode on AppLocale {
  String get code => switch (this) {
    AppLocale.english => 'en',
    AppLocale.arabic => 'ar',
  };
}
