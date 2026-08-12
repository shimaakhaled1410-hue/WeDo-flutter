import 'package:equatable/equatable.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String? taskId;
  final String? projectName;
  final String? projectId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.taskId,
    this.projectName,
    this.projectId,
    required this.createdAt,
    required this.isRead,
  });
  

  @override
  List<Object?> get props => [id, title, body, taskId, projectName, projectId, createdAt, isRead];
}

extension NotificationProjectX on NotificationEntity {
  ProjectEntity? toProjectEntity() {
    if (projectId == null || projectId!.isEmpty) return null;
    return ProjectEntity(
      id: projectId!,
      name: projectName ?? 'Project',
      iconCodePoint: 61585,
      createdAt: DateTime.now(),
      ownerId: '',
    );
  }
}