import 'package:equatable/equatable.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class AddProjectLoading extends ProjectState {}

class AddProjectSuccess extends ProjectState {
  final ProjectEntity project;
  const AddProjectSuccess(this.project);

  @override
  List<Object?> get props => [project];
}

class AddProjectError extends ProjectState {
  final String message;
  const AddProjectError(this.message);

  @override
  List<Object?> get props => [message];
}

class GetProjectsLoading extends ProjectState {}

class GetProjectsSuccess extends ProjectState {
  final List<ProjectEntity> projects;
  const GetProjectsSuccess(this.projects);

  @override
  List<Object?> get props => [projects];
}

class GetProjectsError extends ProjectState {
  final String message;
  const GetProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}