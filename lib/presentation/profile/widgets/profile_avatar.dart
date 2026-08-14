import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_color_scheme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageBytes,
    required this.user,
    required this.onTap,
    this.isUploading = false,
  });

  final Uint8List? imageBytes;
  final User? user;
  final VoidCallback onTap;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool hasImage = imageBytes != null || user?.photoURL != null;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              boxShadow: colors.softShadow,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: colors.primaryLight,
              backgroundImage: imageBytes != null
                  ? MemoryImage(imageBytes!)
                  : (user?.photoURL != null
                        ? NetworkImage(user!.photoURL!) as ImageProvider
                        : null),
              child: !hasImage
                  ? Icon(
                      Icons.person_outline_rounded,
                      color: colors.primary,
                      size: 48,
                    )
                  : null,
            ),
          ),
          if (isUploading)
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.35),
              ),
              child: const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: colors.accentGradient,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 2.5),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
