import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';

class AddProjectUsecase {
  final ProjectRepo repo;
  AddProjectUsecase(this.repo);

  Future<Either<Failure, ProjectEntity>> call({
    required ProjectEntity project,
  }) {
    return repo.addProject(project: project);
  }
}
