import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';
import 'package:wedo_flutter/domain/usecases/theme/get_theme_mode_usecase.dart';
import 'package:wedo_flutter/domain/usecases/theme/set_theme_mode_usecase.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._getThemeMode, this._setThemeMode)
    : super(const ThemeState(AppThemeMode.system)) {
    _loadSavedThemeMode();
  }

  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;

  Future<void> _loadSavedThemeMode() async {
    final savedMode = await _getThemeMode();
    emit(ThemeState(savedMode));
  }

  Future<void> changeThemeMode(AppThemeMode mode) async {
    emit(ThemeState(mode));
    await _setThemeMode(mode);
  }
}
