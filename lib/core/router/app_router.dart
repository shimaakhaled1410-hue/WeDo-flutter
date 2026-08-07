import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/presentation/auth/login_screen.dart';
import 'package:wedo_flutter/presentation/auth/register_screen.dart';
import 'package:wedo_flutter/core/service_locator.dart' as di;
import 'package:wedo_flutter/presentation/home/home_screen.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser != null
        ? AppRoutes.home
        : AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<ProjectCubit>()..fetchProjects(),
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
