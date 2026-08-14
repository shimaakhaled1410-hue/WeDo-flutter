import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';
import 'package:wedo_flutter/domain/repo/theme_repo.dart';

class GetThemeModeUseCase {
  const GetThemeModeUseCase(this._repository);

  final ThemeRepo _repository;

  Future<AppThemeMode> call() => _repository.getThemeMode();
}
