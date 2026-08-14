import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/app_locale.dart';
import 'package:wedo_flutter/domain/usecases/locale/get_locale_usecase.dart';
import 'package:wedo_flutter/domain/usecases/locale/set_locale_usecase.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._getLocale, this._setLocale)
    : super(const LocaleState(AppLocale.english)) {
    _loadSavedLocale();
  }

  final GetLocaleUseCase _getLocale;
  final SetLocaleUseCase _setLocale;

  Future<void> _loadSavedLocale() async {
    final savedLocale = await _getLocale();
    emit(LocaleState(savedLocale));
  }

  Future<void> changeLocale(AppLocale locale) async {
    emit(LocaleState(locale));
    await _setLocale(locale);
  }
}
