import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/data/datasource/image_remote_datasource.dart';
import 'package:wedo_flutter/domain/usecases/auth/login_usecase.dart';
import 'package:wedo_flutter/domain/usecases/auth/register_usecase.dart';
import 'package:wedo_flutter/domain/usecases/auth/sign_out_usecase.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SignOutUsecase signOutUsecase;
  final FirebaseAuth firebaseAuth;
  final ImageRemoteDataSource imageRemoteDataSource;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.signOutUsecase,
    required this.firebaseAuth,
    required this.imageRemoteDataSource,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await signOutUsecase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> updateProfileImage(Uint8List bytes) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    emit(AuthLoading());
    try {
      final photoUrl = await imageRemoteDataSource.uploadImage(bytes, user.uid);

      await user.updatePhotoURL(photoUrl);
      await user.reload();

      emit(ProfileImageUpdated(photoUrl));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
