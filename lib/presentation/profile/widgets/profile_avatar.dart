import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final User? user;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.imageBytes,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: imageBytes != null
                ? MemoryImage(imageBytes!)
                : (user?.photoURL != null
                      ? NetworkImage(user!.photoURL!) as ImageProvider
                      : null),
            child: (imageBytes == null && user?.photoURL == null)
                ? const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 56,
                  )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 14,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
