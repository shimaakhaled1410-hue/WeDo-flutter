import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/presentation/home/add_project_sheet/add_project_bottom_sheet.dart';
import 'package:wedo_flutter/presentation/home/add_project_sheet/edit_project_bottom_sheet.dart';
import 'package:wedo_flutter/presentation/home/widgets/delete_project_dialog.dart';
import 'package:wedo_flutter/presentation/home/widgets/home_greeting_section.dart';
import 'package:wedo_flutter/presentation/home/widgets/home_top_bar.dart';
import 'package:wedo_flutter/presentation/home/widgets/project_card/project_card.dart';
import 'package:wedo_flutter/core/widgets/project_icon_helper.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddProjectSheet(BuildContext context) {
    final projectCubit = context.read<ProjectCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: projectCubit,
        child: const AddProjectBottomSheet(),
      ),
    );
  }

  void _openEditProjectSheet(BuildContext context, project) {
    final projectCubit = context.read<ProjectCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: projectCubit,
        child: EditProjectBottomSheet(project: project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeTopBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: const HomeGreetingSection(),
            ),
            Expanded(
              child: BlocBuilder<ProjectCubit, ProjectState>(
                builder: (context, state) {
                  final cubit = context.read<ProjectCubit>();

                  if (state is GetProjectsLoading &&
                      cubit.projectsList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is GetProjectsError &&
                      cubit.projectsList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  if (cubit.projectsList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.folder_open_rounded,
                                color: AppColors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'No projects yet',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tap "add" below to create your first project.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 90),
                    itemCount: cubit.projectsList.length,
                    itemBuilder: (context, index) {
                      final project = cubit.projectsList[index];
                      return ProjectCard(
                        title: project.name,
                        completedTasks: project.completedTasks,
                        totalTasks: project.totalTasks,
                        icon: getProjectIcon(project.iconCodePoint),
                        collaboratorsImages: project.collaboratorsImages,
                        onTap: () async {
                          await context.push(
                            AppRoutes.projectDetails,
                            extra: project,
                          );
                          if (context.mounted) {
                            context.read<ProjectCubit>().fetchProjects();
                          }
                        },
                        onEdit: () => _openEditProjectSheet(context, project),
                        onDelete: () =>
                            showDeleteProjectDialog(context, project),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (buttonContext) {
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              shape: BoxShape.circle,
              boxShadow: AppColors.accentShadow,
            ),
            child: FloatingActionButton(
              onPressed: () => _openAddProjectSheet(buttonContext),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}