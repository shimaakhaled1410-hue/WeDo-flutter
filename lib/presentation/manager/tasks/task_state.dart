import 'package:equatable/equatable.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List get props => [];
}

class TaskInitial extends TaskState {}

class GetTasksLoading extends TaskState {}

class GetTasksSuccess extends TaskState {
  final List tasks;
  const GetTasksSuccess(this.tasks);

  @override
  List get props => [tasks];
}

class GetTasksError extends TaskState {
  final String message;
  const GetTasksError(this.message);

  @override
  List get props => [message];
}

class AddTaskLoading extends TaskState {}

class AddTaskSuccess extends TaskState {
  final TaskEntity task;
  const AddTaskSuccess(this.task);

  @override
  List get props => [task];
}

class AddTaskError extends TaskState {
  final String message;
  const AddTaskError(this.message);

  @override
  List get props => [message];
}

class ToggleTaskStatusSuccess extends TaskState {
  final String taskId;
  final bool isCompleted;
  const ToggleTaskStatusSuccess({
    required this.taskId,
    required this.isCompleted,
  });

  @override
  List get props => [taskId, isCompleted];
}

class ToggleTaskStatusError extends TaskState {
  final String message;
  const ToggleTaskStatusError(this.message);

  @override
  List get props => [message];
}