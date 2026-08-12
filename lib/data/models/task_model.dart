import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.projectId,
    required super.title,
    super.isCompleted,
    required super.createdAt,
    required super.creatorId,
    super.assignedToUserId,
    super.assignedToUserName,
    super.assignedToUserImage,
    super.alertTime,
    super.alertSent,
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
      creatorId: map['creatorId'] ?? '',
      assignedToUserId: map['assignedToUserId'],
      assignedToUserName: map['assignedToUserName'],
      assignedToUserImage: map['assignedToUserImage'],
      alertTime: map['alertTime'] != null
          ? (map['alertTime'] as Timestamp).toDate()
          : null,
      alertSent: map['alertSent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'creatorId': creatorId,
      'assignedToUserId': assignedToUserId,
      'assignedToUserName': assignedToUserName,
      'assignedToUserImage': assignedToUserImage,
      'alertTime': alertTime != null ? Timestamp.fromDate(alertTime!) : null,
      'alertSent': alertSent,
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      projectId: entity.projectId,
      title: entity.title,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      creatorId: entity.creatorId,
      assignedToUserId: entity.assignedToUserId,
      assignedToUserName: entity.assignedToUserName,
      assignedToUserImage: entity.assignedToUserImage,
      alertTime: entity.alertTime,
      alertSent: entity.alertSent,
    );
  }
}
