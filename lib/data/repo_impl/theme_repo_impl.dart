import 'package:wedo_flutter/data/datasource/theme_local_datasource.dart';
import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';
import 'package:wedo_flutter/domain/repo/theme_repo.dart';

class ThemeRepoImpl implements ThemeRepo {
  const ThemeRepoImpl(this._localDataSource);

  final ThemeLocalDataSource _localDataSource;

  @override
  Future<AppThemeMode> getThemeMode() => _localDataSource.getThemeMode();

  @override
  Future<void> setThemeMode(AppThemeMode mode) =>
      _localDataSource.setThemeMode(mode);
}
