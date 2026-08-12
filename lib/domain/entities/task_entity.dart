import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final String creatorId;
  final String? assignedToUserId;
  final String? assignedToUserName;
  final String? assignedToUserImage;
  final DateTime? alertTime;
  final bool alertSent;

  const TaskEntity({
    required this.id,
    required this.projectId,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    required this.creatorId,
    this.assignedToUserId,
    this.assignedToUserName,
    this.assignedToUserImage,
    this.alertTime,
    this.alertSent = false,
  });

  bool canToggleCompletion(String currentUserId) {
    if (assignedToUserId != null) {
      return currentUserId == assignedToUserId;
    }
    return currentUserId == creatorId;
  }

  bool canEditTitle(String currentUserId) {
    return currentUserId == creatorId;
  }

  bool canDelete(String currentUserId, String projectOwnerId) {
    return currentUserId == creatorId || currentUserId == projectOwnerId;
  }

  bool canReassign(String currentUserId, String projectOwnerId) {
    return currentUserId == projectOwnerId || currentUserId == creatorId;
  }

  TaskEntity copyWith({
    String? id,
    String? projectId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? creatorId,
    String? assignedToUserId,
    String? assignedToUserName,
    String? assignedToUserImage,
    DateTime? alertTime,
    bool? alertSent,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      creatorId: creatorId ?? this.creatorId,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUserName: assignedToUserName ?? this.assignedToUserName,
      assignedToUserImage: assignedToUserImage ?? this.assignedToUserImage,
      alertTime: alertTime ?? this.alertTime,
      alertSent: alertSent ?? this.alertSent,
    );
  }

  @override
  List get props => [
    id,
    projectId,
    title,
    isCompleted,
    createdAt,
    creatorId,
    assignedToUserId,
    assignedToUserName,
    assignedToUserImage,
    alertTime,
    alertSent,
  ];
}
