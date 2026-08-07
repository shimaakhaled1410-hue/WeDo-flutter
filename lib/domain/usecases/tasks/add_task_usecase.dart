import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/repo/task_repo.dart';

class AddTaskUsecase {
  final TaskRepo repo;

  AddTaskUsecase(this.repo);

  Future<Either<Failure, TaskEntity>> call({required TaskEntity task}) {
    return repo.addTask(task: task);
  }
}
