import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';

class DeleteProjectUsecase {
  final ProjectRepo repo;
  DeleteProjectUsecase(this.repo);

  Future<Either<Failure, void>> call({required String projectId}) {
    return repo.deleteProject(projectId: projectId);
  }
}
