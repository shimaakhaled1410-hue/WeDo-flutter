import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final String? assignedToUserId;
  final String? assignedToUserName;
  final String? assignedToUserImage;

  const TaskEntity({
    required this.id,
    required this.projectId,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.assignedToUserId,
    this.assignedToUserName,
    this.assignedToUserImage,
  });

  TaskEntity copyWith({
    String? id,
    String? projectId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? assignedToUserId,
    String? assignedToUserName,
    String? assignedToUserImage,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUserName: assignedToUserName ?? this.assignedToUserName,
      assignedToUserImage: assignedToUserImage ?? this.assignedToUserImage,
    );
  }

  @override
  List get props => [
    id,
    projectId,
    title,
    isCompleted,
    createdAt,
    assignedToUserId,
    assignedToUserName,
    assignedToUserImage,
  ];
}
