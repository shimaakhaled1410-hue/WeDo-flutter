import 'package:wedo_flutter/data/datasource/locale_local_datasource.dart';
import 'package:wedo_flutter/domain/entities/app_locale.dart';
import 'package:wedo_flutter/domain/repo/locale_repo.dart';

class LocaleRepoImpl implements LocaleRepo {
  const LocaleRepoImpl(this._localDataSource);

  final LocaleLocalDataSource _localDataSource;

  @override
  Future<AppLocale> getLocale() => _localDataSource.getLocale();

  @override
  Future<void> setLocale(AppLocale locale) =>
      _localDataSource.setLocale(locale);
}