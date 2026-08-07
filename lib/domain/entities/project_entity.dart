import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id; 
  final String name;
  final int iconCodePoint; 
  final int completedTasks; 
  final int totalTasks;
  final List<String> collaboratorsImages;
  final DateTime createdAt;
  final String ownerId;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.completedTasks = 0, 
    this.totalTasks = 0,
    this.collaboratorsImages = const [],
    required this.createdAt,
    required this.ownerId,
  });

  ProjectEntity copyWith({
    String? id,
    String? name,
    String? ownerId,
    int? iconCodePoint,
    int? totalTasks,
    int? completedTasks,
    List<String>? collaboratorsImages,
    DateTime? createdAt,
  }) {
    return ProjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      collaboratorsImages: collaboratorsImages ?? this.collaboratorsImages,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List get props => [
        id,
        name,
        iconCodePoint,
        completedTasks,
        totalTasks,
        collaboratorsImages,
        createdAt,
        ownerId,
      ];
}