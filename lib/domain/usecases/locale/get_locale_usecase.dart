import 'package:wedo_flutter/domain/entities/app_locale.dart';
import 'package:wedo_flutter/domain/repo/locale_repo.dart';

class GetLocaleUseCase {
  const GetLocaleUseCase(this._repo);

  final LocaleRepo _repo;

  Future<AppLocale> call() => _repo.getLocale();
}