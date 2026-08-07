import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textLight,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}