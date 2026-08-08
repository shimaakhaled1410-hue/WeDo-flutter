import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';

class JoinProjectById {
  final ProjectRepo repo;

  JoinProjectById(this.repo);

  Future<Either<Failure, void>> call(String projectId) {
    return repo.joinProjectById(projectId: projectId);
  }
}
