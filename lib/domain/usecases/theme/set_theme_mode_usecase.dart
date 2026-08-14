import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';
import 'package:wedo_flutter/domain/repo/theme_repo.dart';

class SetThemeModeUseCase {
  const SetThemeModeUseCase(this._repository);

  final ThemeRepo _repository;

  Future<void> call(AppThemeMode mode) => _repository.setThemeMode(mode);
}
