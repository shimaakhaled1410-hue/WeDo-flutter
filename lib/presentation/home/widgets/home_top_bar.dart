import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../home/widgets/notification_icon.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                colors.primaryGradient.createShader(bounds),
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
              GestureDetector(
                onTap: () => context.push(AppRoutes.profile),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.surface,
                  backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                      ? NetworkImage(photoUrl)
                      : null,
                  child: (photoUrl == null || photoUrl.isEmpty)
                      ? Icon(
                          Icons.person_outline,
                          color: colors.primary,
                          size: 18,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
