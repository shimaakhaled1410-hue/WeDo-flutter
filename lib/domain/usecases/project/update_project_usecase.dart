import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';

class UpdateProjectUsecase {
  final ProjectRepo repo;
  UpdateProjectUsecase(this.repo);

  Future<Either<Failure, void>> call({required ProjectEntity project}) {
    return repo.updateProject(project: project);
  }
}
