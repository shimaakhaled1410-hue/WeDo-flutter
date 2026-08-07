import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/repo/auth_repo.dart';

class SignOutUsecase {
  final AuthRepo repo;

  SignOutUsecase(this.repo);

  Future<Either<Failure, void>> call() {
    return repo.signOut();
  }
}