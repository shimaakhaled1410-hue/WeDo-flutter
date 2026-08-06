import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/domain/entities/user_entity.dart';
import 'package:wedo_flutter/domain/repo/auth_repo.dart';
import '../../../../core/error/failure.dart';

class RegisterUseCase {
  final AuthRepo repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}