import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';

abstract class TaskRepo {
  Future<Either<Failure, TaskEntity>> addTask({
    required TaskEntity task,
  });

  Future<Either<Failure, List<TaskEntity>>> getTasks({
    required String projectId,
  });

  Future<Either<Failure, void>> toggleTaskStatus({
    required TaskEntity task,
  });
}

   

