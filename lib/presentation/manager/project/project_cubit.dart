import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/domain/usecases/project/add_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/get_projects_usecase.dart';
import 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final AddProjectUsecase addProjectUsecase;
  final GetProjectsUsecase getProjectsUsecase;

  ProjectCubit({
    required this.addProjectUsecase,
    required this.getProjectsUsecase,
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

    result.fold(
      (failure) => emit(AddProjectError(failure.message)),
      (createdProject) {
        projectsList.insert(0, createdProject); 
        emit(AddProjectSuccess(createdProject));
      },
    );
  }

  Future<void> fetchProjects() async {
    emit(GetProjectsLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(const GetProjectsError('User not authenticated'));
      return;
    }

    final result = await getProjectsUsecase(userId: currentUser.uid);

    result.fold(
      (failure) => emit(GetProjectsError(failure.message)),
      (projects) {
        projectsList = projects;
        emit(GetProjectsSuccess(projects));
      },
    );
  }
}