import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';

class GetProjectsUsecase {
  final ProjectRepo repo;
  GetProjectsUsecase(this.repo);

  Future<Either<Failure, List<ProjectEntity>>> call({required String userId}) {
    return repo.getProjects(userId: userId);
  }
}
