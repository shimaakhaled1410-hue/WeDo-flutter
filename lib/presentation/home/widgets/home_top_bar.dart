import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../manager/auth/auth_cubit.dart';
import '../../manager/auth/auth_state.dart';
import 'notification_icon.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => colors.primaryGradient.createShader(bounds),
            child: const Text(
              'WeDo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            children: [
              const NotificationIcon(),
              const SizedBox(width: 10),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final photoUrl =
                      context.read<AuthCubit>().firebaseAuth.currentUser?.photoURL;

                  return GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: colors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: colors.surface,
                        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? Icon(Icons.person_outline, color: colors.primary, size: 18)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}