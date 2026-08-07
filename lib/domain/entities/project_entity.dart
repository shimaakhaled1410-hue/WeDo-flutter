import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id; 
  final String name;
  final int iconCodePoint; 
  final int completedTasks; 
  final int totalTasks;
  final List collaboratorsImages;
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