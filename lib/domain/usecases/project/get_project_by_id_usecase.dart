import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/project_entity.dart';
import '../../repo/project_repo.dart';

class GetProjectByIdUseCase {
  const GetProjectByIdUseCase(this._repo);

  final ProjectRepo _repo;

  Future<Either<Failure, ProjectEntity>> call(String projectId) =>
      _repo.getProjectById(projectId);
}