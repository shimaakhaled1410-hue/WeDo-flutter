import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/presentation/home/widgets/notification_icon.dart';


class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.primaryGradient.createShader(bounds),
            child: const Text(
              'WeDo',
              style: TextStyle(
                color: AppColors.white, // masked by the gradient
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
              GestureDetector(
                onTap: () => context.push(AppRoutes.profile),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.surface,
                    backgroundImage:
                        (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                    child: (photoUrl == null || photoUrl.isEmpty)
                        ? const Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                            size: 18,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}