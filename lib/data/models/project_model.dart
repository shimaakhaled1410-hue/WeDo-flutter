import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.iconCodePoint,
    super.completedTasks,
    super.totalTasks,
    super.collaboratorsImages,
    required super.createdAt,
    required super.ownerId,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      name: map['name'] ?? '',
      iconCodePoint: map['iconCodePoint'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      totalTasks: map['totalTasks'] ?? 0,
      collaboratorsImages: List<String>.from(map['collaboratorsImages'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      ownerId: map['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': iconCodePoint,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'collaboratorsImages': collaboratorsImages,
      'createdAt': Timestamp.fromDate(createdAt),
      'ownerId': ownerId,
    };
  }

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      iconCodePoint: entity.iconCodePoint,
      completedTasks: entity.completedTasks,
      totalTasks: entity.totalTasks,
      collaboratorsImages: entity.collaboratorsImages,
      createdAt: entity.createdAt,
      ownerId: entity.ownerId,
    );
  }
}
