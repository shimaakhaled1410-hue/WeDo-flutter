import 'package:equatable/equatable.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String? taskId;
  final String? projectName;
  final String? projectId;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    this.taskId,
    this.projectName,
    this.projectId,
    required this.createdAt,
    required this.isRead,
  });

  String title(String localeCode) => localeCode == 'ar' ? titleAr : titleEn;
  String body(String localeCode) => localeCode == 'ar' ? bodyAr : bodyEn;

  @override
  List<Object?> get props => [
    id,
    titleEn,
    titleAr,
    bodyEn,
    bodyAr,
    taskId,
    projectName,
    projectId,
    createdAt,
    isRead,
  ];
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