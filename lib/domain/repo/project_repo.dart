import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/project_entity.dart';

abstract class ProjectRepo {
  Future<Either<Failure, ProjectEntity>> addProject({
    required ProjectEntity project,
  });

  Future<Either<Failure, List<ProjectEntity>>> getProjects({
    required String userId,
  });
  Future<Either<Failure, void>> deleteProject({
    required String projectId,
  });
  Future<Either<Failure, void>> updateProject({
    required ProjectEntity project,
  });
  Future<Either<Failure, void>> joinProjectById({
    required String projectId,
  });
}
