import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/repo/task_repo.dart';

class DeleteTaskUsecase {
  final TaskRepo repo;
  DeleteTaskUsecase(this.repo);

  Future<Either<Failure, void>> call({required TaskEntity task}) {
    return repo.deleteTask(task: task);
  }
}
