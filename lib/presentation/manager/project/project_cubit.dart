import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/usecases/project/add_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/delete_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/get_projects_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/update_project_usecase.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final AddProjectUsecase addProjectUsecase;
  final GetProjectsUsecase getProjectsUsecase;
  final DeleteProjectUsecase deleteProjectUsecase;
  final UpdateProjectUsecase updateProjectUsecase;

  ProjectCubit({
    required this.addProjectUsecase,
    required this.getProjectsUsecase,
    required this.deleteProjectUsecase,
    required this.updateProjectUsecase,
  }) : super(ProjectInitial());

  List<ProjectEntity> projectsList = [];

  Future<void> createProject({
    required String name,
    required int iconCodePoint,
  }) async {
    emit(AddProjectLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(const AddProjectError('User not authenticated'));
      return;
    }

    final newProject = ProjectEntity(
      id: '',
      name: name,
      iconCodePoint: iconCodePoint,
      createdAt: DateTime.now(),
      ownerId: currentUser.uid,
    );

    final result = await addProjectUsecase(project: newProject);

    result.fold((failure) => emit(AddProjectError(failure.message)), (
      createdProject,
    ) {
      projectsList.insert(0, createdProject);
      emit(AddProjectSuccess(createdProject));
    });
  }

  Future<void> fetchProjects() async {
    emit(GetProjectsLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(const GetProjectsError('User not authenticated'));
      return;
    }

    final result = await getProjectsUsecase(userId: currentUser.uid);

    result.fold((failure) => emit(GetProjectsError(failure.message)), (
      projects,
    ) {
      projectsList = List<ProjectEntity>.from(projects);
      emit(GetProjectsSuccess(projects));
    });
  }

  Future<void> updateProject(ProjectEntity project) async {
    final index = projectsList.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projectsList[index] = project;
      emit(GetProjectsSuccess(List<ProjectEntity>.from(projectsList)));
    }

    final result = await updateProjectUsecase(project: project);
    result.fold((failure) {
      fetchProjects();
      emit(GetProjectsError(failure.message));
    }, (_) {});
  }

  Future<void> deleteProject(String projectId) async {
    projectsList.removeWhere((p) => p.id == projectId);
    emit(GetProjectsSuccess(List<ProjectEntity>.from(projectsList)));

    final result = await deleteProjectUsecase(projectId: projectId);
    result.fold((failure) {
      fetchProjects();
      emit(GetProjectsError(failure.message));
    }, (_) {});
  }
}
