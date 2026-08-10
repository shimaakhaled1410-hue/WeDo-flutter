import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/usecases/tasks/add_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/delete_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/toggle_task_status_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/update_task_usecase.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_state.dart';

enum TaskFilter { all, myTasks, pending, completed }

class TaskCubit extends Cubit<TaskState> {
  final AddTaskUsecase addTaskUsecase;
  final GetTasksUsecase getTasksUsecase;
  final ToggleTaskStatusUsecase toggleTaskStatusUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;
  final UpdateTaskUsecase updateTaskUsecase;

  TaskCubit({
    required this.addTaskUsecase,
    required this.getTasksUsecase,
    required this.toggleTaskStatusUsecase,
    required this.deleteTaskUsecase,
    required this.updateTaskUsecase,
  }) : super(TaskInitial());

  List<TaskEntity> tasksList = [];
  StreamSubscription? _tasksSubscription;

  TaskFilter currentFilter = TaskFilter.all;

  void changeFilter(TaskFilter filter) {
    if (currentFilter == filter) return;

    currentFilter = filter;

    emit(TaskInitial());
    emit(GetTasksSuccess(tasksList));
  }

  List<TaskEntity> get filteredTasks {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    switch (currentFilter) {
      case TaskFilter.all:
        return tasksList;
      case TaskFilter.myTasks:
        return tasksList
            .where((t) => t.assignedToUserId == currentUserId)
            .toList();
      case TaskFilter.pending:
        return tasksList.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasksList.where((t) => t.isCompleted).toList();
    }
  }

  void startListeningToTasks(String projectId) {
    emit(GetTasksLoading());

    _tasksSubscription?.cancel();

    _tasksSubscription = getTasksUsecase(projectId: projectId).listen(
      (result) {
        result.fold((failure) => emit(GetTasksError(failure.message)), (tasks) {
          tasksList = List<TaskEntity>.from(tasks);
          emit(GetTasksSuccess(tasksList));
        });
      },
      onError: (error) {
        emit(GetTasksError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }

  Future createTask({
    required String projectId,
    required String title,
    required String creatorId,
    String? assignedToUserId,
    String? assignedToUserImage,
    String? assignedToUserName,
    DateTime? alertTime,
  }) async {
    emit(AddTaskLoading());

    final newTask = TaskEntity(
      id: '',
      projectId: projectId,
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
      creatorId: creatorId,
      assignedToUserId: assignedToUserId,
      assignedToUserImage: assignedToUserImage,
      assignedToUserName: assignedToUserName,
      alertTime: alertTime,
    );

    final result = await addTaskUsecase(task: newTask);

    result.fold(
      (failure) => emit(AddTaskError(failure.message)),
      (createdTask) => emit(AddTaskSuccess(createdTask)),
    );
  }

  Future<void> toggleTask(TaskEntity task) async {
    final result = await toggleTaskStatusUsecase(task: task);

    result.fold(
      (failure) => emit(ToggleTaskStatusError(failure.message)),
      (_) {},
    );
  }

  Future<void> deleteTask(TaskEntity task) async {
    final result = await deleteTaskUsecase(task: task);

    result.fold((failure) => emit(GetTasksError(failure.message)), (_) {});
  }

  Future<void> updateTask(TaskEntity task, String newTitle) async {
    final updated = task.copyWith(title: newTitle);
    final result = await updateTaskUsecase(task: updated);

    result.fold((failure) => emit(GetTasksError(failure.message)), (_) {});
  }
}
