import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_state.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/profile/widgets/profile_avatar.dart';
import 'package:wedo_flutter/presentation/profile/widgets/profile_setting_tile.dart';
import 'package:wedo_flutter/presentation/profile/widgets/profile_stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _imageBytes;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });

      if (mounted) {
        context.read<AuthCubit>().updateProfileImage(bytes);
      }
    }
  }

  @override
  void dispose() {
    _imageBytes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final projectsList = context.watch<ProjectCubit>().projectsList;

    final totalProjects = projectsList.length;
    final completedTasksCount = projectsList.fold<int>(
      0,
      (sum, project) => sum + project.completedTasks,
    );

    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'User');

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(AppRoutes.login);
        } else if (state is AuthLoading) {
          setState(() => _isUploading = true);
        } else if (state is ProfileImageUpdated) {
          setState(() => _isUploading = false);
          CustomSnackBar.show(
            context: context,
            message: 'Profile image updated successfully!',
          );
        } else if (state is AuthError) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'My profile',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  ProfileAvatar(
                    imageBytes: _imageBytes,
                    user: user,
                    onTap: _isUploading ? () {} : _pickImage,
                  ),
                  if (_isUploading)
                    const CircularProgressIndicator(color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'No Email Provided',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: ProfileStatCard(
                      title: 'Projects',
                      value: '$totalProjects',
                      icon: Icons.folder_open_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ProfileStatCard(
                      title: 'Done Tasks',
                      value: '$completedTasksCount',
                      icon: Icons.task_alt_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Settings List
              Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ProfileSettingsTile(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      trailingText: 'English',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ProfileSettingsTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ProfileSettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Theme Mode',
                      trailingText: 'Light',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
