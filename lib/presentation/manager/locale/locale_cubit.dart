import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/app_locale.dart';
import 'package:wedo_flutter/domain/usecases/locale/get_locale_usecase.dart';
import 'package:wedo_flutter/domain/usecases/locale/set_locale_usecase.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(
    this._getLocale,
    this._setLocale, {
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       super(const LocaleState(AppLocale.english)) {
    _loadSavedLocale();
  }

  final GetLocaleUseCase _getLocale;
  final SetLocaleUseCase _setLocale;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Future<void> _loadSavedLocale() async {
    final savedLocale = await _getLocale();
    emit(LocaleState(savedLocale));
  }

  Future<void> changeLocale(AppLocale locale) async {
    emit(LocaleState(locale));
    await _setLocale(locale);
    await _syncToFirestore(locale);
  }

  Future<void> syncCurrentLocale() async {
    await _syncToFirestore(state.locale);
  }

  Future<void> _syncToFirestore(AppLocale locale) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      'locale': locale.code,
    }, SetOptions(merge: true));
  }
}
