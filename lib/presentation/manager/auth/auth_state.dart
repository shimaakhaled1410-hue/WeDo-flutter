import 'package:wedo_flutter/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class ProfileImageUpdated extends AuthState {
  final String photoUrl;
  ProfileImageUpdated(this.photoUrl);

  List<Object?> get props => [photoUrl];
}
