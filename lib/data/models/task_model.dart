import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.projectId,
    required super.title,
    super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromMap(Map map, String docId) {
    return TaskModel(
      id: docId,
      projectId: map['projectId'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      projectId: entity.projectId,
      title: entity.title,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
    );
  }
}
