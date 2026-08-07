import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<TaskModel> addTask(TaskModel task);
  Future<List<TaskModel>> getTasks(String projectId);
  Future<void> toggleTaskStatus(TaskModel task);
  Future<void> deleteTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl(this.firestore);

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final taskDocRef = firestore.collection('tasks').doc();

    final taskToSave = TaskModel(
      id: taskDocRef.id,
      projectId: task.projectId,
      title: task.title,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );

    await taskDocRef.set(taskToSave.toMap());

    final projectDocRef = firestore.collection('projects').doc(task.projectId);
    await projectDocRef.update({'totalTasks': FieldValue.increment(1)});

    return taskToSave;
  }

  @override
  Future<List<TaskModel>> getTasks(String projectId) async {
    final querySnapshot = await firestore
        .collection('tasks')
        .where('projectId', isEqualTo: projectId)
        // .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> toggleTaskStatus(TaskModel task) async {
    final newStatus = !task.isCompleted;

    await firestore.collection('tasks').doc(task.id).update({
      'isCompleted': newStatus,
    });

    final projectDocRef = firestore.collection('projects').doc(task.projectId);
    await projectDocRef.update({
      'completedTasks': FieldValue.increment(newStatus ? 1 : -1),
    });
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    await firestore.collection('tasks').doc(task.id).delete();

    final projectDocRef = firestore.collection('projects').doc(task.projectId);
    await projectDocRef.update({
      'totalTasks': FieldValue.increment(-1),
      if (task.isCompleted) 'completedTasks': FieldValue.increment(-1),
    });
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
    });
  }
}
