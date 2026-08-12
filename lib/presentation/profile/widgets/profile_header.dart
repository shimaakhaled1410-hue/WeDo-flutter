import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'profile_avatar.dart';


class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.imageBytes,
    required this.user,
    required this.displayName,
    required this.isUploading,
    required this.onAvatarTap,
    required this.onBackTap,
  });

  final Uint8List? imageBytes;
  final User? user;
  final String displayName;
  final bool isUploading;
  final VoidCallback onAvatarTap;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 52,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBackTap,
                ),
                const Expanded(
                  child: Text(
                    'My Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ProfileAvatar(
            imageBytes: imageBytes,
            user: user,
            isUploading: isUploading,
            onTap: onAvatarTap,
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'No Email Provided',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.white, size: 16),
      ),
    );
  }
}