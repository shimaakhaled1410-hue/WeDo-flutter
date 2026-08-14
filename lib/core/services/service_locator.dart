import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:wedo_flutter/data/datasource/auth_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/image_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/notification_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/project_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/task_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/theme_local_datasource.dart';
import 'package:wedo_flutter/data/repo_impl/auth_repo_impl.dart';
import 'package:wedo_flutter/data/repo_impl/notification_repo_impl.dart';
import 'package:wedo_flutter/data/repo_impl/project_repo_impl.dart';
import 'package:wedo_flutter/data/repo_impl/task_repo_impl.dart';
import 'package:wedo_flutter/data/repo_impl/theme_repo_impl.dart';
import 'package:wedo_flutter/domain/repo/auth_repo.dart';
import 'package:wedo_flutter/domain/repo/notification_repo.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';
import 'package:wedo_flutter/domain/repo/task_repo.dart';
import 'package:wedo_flutter/domain/repo/theme_repo.dart';
import 'package:wedo_flutter/domain/usecases/auth/login_usecase.dart';
import 'package:wedo_flutter/domain/usecases/auth/register_usecase.dart';
import 'package:wedo_flutter/domain/usecases/auth/sign_out_usecase.dart';
import 'package:wedo_flutter/domain/usecases/notifications/get_notifications_usecase.dart';
import 'package:wedo_flutter/domain/usecases/notifications/mark_notification_as_read_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/add_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/delete_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/get_projects_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/join_project_by_id.dart';
import 'package:wedo_flutter/domain/usecases/project/update_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/add_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/delete_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/get_tasks_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/toggle_task_status_usecase.dart';
import 'package:wedo_flutter/domain/usecases/tasks/update_task_usecase.dart';
import 'package:wedo_flutter/domain/usecases/theme/get_theme_mode_usecase.dart';
import 'package:wedo_flutter/domain/usecases/theme/set_theme_mode_usecase.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/notifications/notification_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'package:wedo_flutter/presentation/manager/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //auth
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      signOutUsecase: sl(),
      firebaseAuth: sl(),
      imageRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<ImageRemoteDataSource>(
    () => ImageRemoteDataSourceImpl(client: sl()),
  );

  //external services
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //project
  sl.registerFactory(
    () => ProjectCubit(
      addProjectUsecase: sl(),
      getProjectsUsecase: sl(),
      deleteProjectUsecase: sl(),
      updateProjectUsecase: sl(),
      joinProjectByIdUsecase: sl(),
    ),
  );

  sl.registerLazySingleton(() => AddProjectUsecase(sl()));
  sl.registerLazySingleton(() => GetProjectsUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUsecase(sl()));
  sl.registerLazySingleton(() => JoinProjectById(sl()));

  sl.registerLazySingleton<ProjectRepo>(() => ProjectRepoImpl(sl()));

  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(sl(), sl()),
  );

  //tasks
  sl.registerFactory(
    () => TaskCubit(
      addTaskUsecase: sl(),
      getTasksUsecase: sl(),
      toggleTaskStatusUsecase: sl(),
      deleteTaskUsecase: sl(),
      updateTaskUsecase: sl(),
    ),
  );
  sl.registerLazySingleton(() => AddTaskUsecase(sl()));
  sl.registerLazySingleton(() => GetTasksUsecase(sl()));
  sl.registerLazySingleton(() => ToggleTaskStatusUsecase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUsecase(sl()));

  sl.registerLazySingleton<TaskRepo>(() => TaskRepoImpl(sl()));

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  // notifications
  sl.registerFactory(
    () => NotificationCubit(
      getNotificationsUseCase: sl(),
      markNotificationAsReadUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  //theme
  sl.registerFactory(
    () => ThemeCubit(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SetThemeModeUseCase(sl()));

  sl.registerLazySingleton<ThemeRepo>(() => ThemeRepoImpl(sl()));

  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(),
  );
}
