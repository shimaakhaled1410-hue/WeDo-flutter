import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/presentation/auth/login_screen.dart';
import 'package:wedo_flutter/presentation/auth/register_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.register, 
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}