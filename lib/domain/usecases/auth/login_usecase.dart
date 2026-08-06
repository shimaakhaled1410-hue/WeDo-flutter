import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/domain/entities/user_entity.dart';
import 'package:wedo_flutter/domain/repo/auth_repo.dart';
import '../../../../core/error/failure.dart';

class LoginUseCase {
  final AuthRepo repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
