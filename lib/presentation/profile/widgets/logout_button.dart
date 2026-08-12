import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.errorLight,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 19),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}