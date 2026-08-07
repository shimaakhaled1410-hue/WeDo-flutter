import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/data/datasource/auth_remote_datasource.dart';
import 'package:wedo_flutter/data/datasource/project_remote_datasource.dart';
import 'package:wedo_flutter/data/repo_impl/auth_repo_impl.dart';
import 'package:wedo_flutter/data/repo_impl/project_repo_impl.dart';
import 'package:wedo_flutter/domain/repo/auth_repo.dart';
import 'package:wedo_flutter/domain/repo/project_repo.dart';
import 'package:wedo_flutter/domain/usecases/auth/login_usecase.dart';
import 'package:wedo_flutter/domain/usecases/auth/register_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/add_project_usecase.dart';
import 'package:wedo_flutter/domain/usecases/project/get_projects_usecase.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //auth
  sl.registerFactory(
    () => AuthCubit(loginUseCase: sl(), registerUseCase: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  //firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //project
  sl.registerFactory(
    () => ProjectCubit(addProjectUsecase: sl(), getProjectsUsecase: sl()),
  );
  sl.registerLazySingleton(() => AddProjectUsecase(sl()));
  sl.registerLazySingleton(() => GetProjectsUsecase(sl()));
  sl.registerLazySingleton<ProjectRepo>(() => ProjectRepoImpl(sl()));

  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(sl()),
  );
}
