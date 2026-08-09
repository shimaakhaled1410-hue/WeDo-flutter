import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/repo/task_repo.dart';

class GetTasksUsecase {
  final TaskRepo repo;

  GetTasksUsecase(this.repo);

  Stream<Either<Failure, List<TaskEntity>>> call({required String projectId}) {
    return repo.getTasks(projectId: projectId);
  }
}
