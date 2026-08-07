import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/data/datasource/project_remote_datasource.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';
import 'package:wedo_flutter/data/models/project_model.dart';

class ProjectRepoImpl implements ProjectRepo {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProjectEntity>> addProject({
    required ProjectEntity project,
  }) async {
    try {
      final projectModel = ProjectModel.fromEntity(project);

      final ProjectEntity result = await remoteDataSource.addProject(
        projectModel,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects({
    required String userId,
  }) async {
    try {
      final List<ProjectModel> result = await remoteDataSource.getProjects(
        userId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
