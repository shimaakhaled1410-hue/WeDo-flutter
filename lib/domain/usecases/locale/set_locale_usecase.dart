import 'package:wedo_flutter/domain/entities/app_locale.dart';
import 'package:wedo_flutter/domain/repo/locale_repo.dart';

class SetLocaleUseCase {
  const SetLocaleUseCase(this._repo);

  final LocaleRepo _repo;

  Future<void> call(AppLocale locale) => _repo.setLocale(locale);
}