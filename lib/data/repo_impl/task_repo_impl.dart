import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/data/datasource/task_remote_datasource.dart';
import 'package:wedo_flutter/data/models/task_model.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/repo/task_repo.dart';

class TaskRepoImpl implements TaskRepo {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TaskEntity>> addTask({required TaskEntity task}) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final TaskEntity result = await remoteDataSource.addTask(taskModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks({required String projectId}) async {
    try {
      final List<TaskModel> result = await remoteDataSource.getTasks(projectId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTaskStatus({required TaskEntity task}) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await remoteDataSource.toggleTaskStatus(taskModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}