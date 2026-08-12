import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/presentation/profile/widgets/profile_setting_tile.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ProfileSettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            trailingText: 'English',
            iconBackground: AppColors.infoLight,
            iconColor: AppColors.info,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 60, endIndent: 16, color: AppColors.divider),
          ProfileSettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            iconBackground: AppColors.warningLight,
            iconColor: AppColors.warning,
            onTap: () {},
          ),
          const Divider(height: 1, indent: 60, endIndent: 16, color: AppColors.divider),
          ProfileSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Theme Mode',
            trailingText: 'Light',
            iconBackground: AppColors.primaryLight,
            iconColor: AppColors.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}