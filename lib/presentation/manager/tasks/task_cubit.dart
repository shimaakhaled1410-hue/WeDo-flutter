import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/domain/usecases/tasks/add_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/toggle_task_status_usecase.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AddTaskUsecase addTaskUsecase;
  final GetTasksUsecase getTasksUsecase;
  final ToggleTaskStatusUsecase toggleTaskStatusUsecase;

  TaskCubit({
    required this.addTaskUsecase,
    required this.getTasksUsecase,
    required this.toggleTaskStatusUsecase,
  }) : super(TaskInitial());

  List<TaskEntity> tasksList = [];

  Future fetchTasks(String projectId) async {
    emit(GetTasksLoading());

    final result = await getTasksUsecase(projectId: projectId);

    result.fold((failure) => emit(GetTasksError(failure.message)), (tasks) {
      tasksList = List<TaskEntity>.from(tasks);
      emit(GetTasksSuccess(tasksList));
    });
  }

  Future createTask({required String projectId, required String title}) async {
    emit(AddTaskLoading());

    final newTask = TaskEntity(
      id: '',
      projectId: projectId,
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    final result = await addTaskUsecase(task: newTask);

    result.fold((failure) => emit(AddTaskError(failure.message)), (
      createdTask,
    ) {
      tasksList.insert(0, createdTask);
      emit(AddTaskSuccess(createdTask));
    });
  }

  Future<void> toggleTask(TaskEntity task) async {
    final index = tasksList.indexWhere((t) => t.id == task.id);
    if (index == -1) return;

    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    tasksList[index] = updatedTask;

    emit(ToggleTaskStatusSuccess(
      taskId: updatedTask.id,
      isCompleted: updatedTask.isCompleted,
    ));

    final result = await toggleTaskStatusUsecase(task: task);

    result.fold(
      (failure) {
        tasksList[index] = task;
        emit(ToggleTaskStatusError(failure.message));
      },
      (_) {},
    );
  }
}
