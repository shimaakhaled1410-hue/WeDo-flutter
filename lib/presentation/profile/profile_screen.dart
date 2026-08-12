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
import 'package:wedo_flutter/presentation/profile/widgets/profile_setting_card.dart';
import 'widgets/logout_button.dart';
import 'widgets/logout_dialog.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stat_card.dart';

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
      setState(() => _imageBytes = bytes);

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
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(
                imageBytes: _imageBytes,
                user: user,
                displayName: displayName,
                isUploading: _isUploading,
                onAvatarTap: _pickImage,
                onBackTap: () => context.pop(),
              ),

              // Stats overlap the header's rounded bottom edge.
              Transform.translate(
                offset: const Offset(0, -34),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProfileStatCard(
                          title: 'Projects',
                          value: '$totalProjects',
                          icon: Icons.folder_open_rounded,
                          iconBackground: AppColors.primaryLight,
                          iconColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileStatCard(
                          title: 'Done Tasks',
                          value: '$completedTasksCount',
                          icon: Icons.task_alt_rounded,
                          iconBackground: AppColors.successLight,
                          iconColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const ProfileSettingsCard(),
                      const SizedBox(height: 28),
                      LogoutButton(
                        onTap: () => showLogoutDialog(
                          context,
                          onConfirm: () =>
                              context.read<AuthCubit>().signOut(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}