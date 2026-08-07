import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/presentation/home/widgets/add_project_buttom_sheet.dart';
import 'package:wedo_flutter/presentation/home/widgets/project_card.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textLight),
          onPressed: () {},
        ),
        title: const Text(
          'WeDo',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'My Lists',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                final count = context.read<ProjectCubit>().projectsList.length;
                return Text(
                  'You have $count active projects',
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
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

                  if (state is GetProjectsError && cubit.projectsList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (cubit.projectsList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No projects yet. Tap "add" to create one!',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.projectsList.length,
                    itemBuilder: (context, index) {
                      final project = cubit.projectsList[index];
                      return ProjectCard(
                        title: project.name,
                        completedTasks: project.completedTasks,
                        totalTasks: project.totalTasks,
                        icon: getProjectIcon(project.iconCodePoint),
                        collaboratorsImages: project.collaboratorsImages,
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
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: buttonContext,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: buttonContext.read<ProjectCubit>(),
                  child: const AddProjectBottomSheet(),
                ),
              );
            },
            backgroundColor: AppColors.accent,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Text(
              'add',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

IconData getProjectIcon(int codePoint) {
  switch (codePoint) {
    case 0xe59c: // Icons.shopping_cart_outlined
      return Icons.shopping_cart_outlined;
    case 0xe190: // Icons.code_rounded
      return Icons.code_rounded;
    case 0xe293: // Icons.flight_takeoff_rounded
      return Icons.flight_takeoff_rounded;
    case 0xe6e0: // Icons.work_outline_rounded
      return Icons.work_outline_rounded;
    case 0xe25b: // Icons.favorite_border_rounded
      return Icons.favorite_border_rounded;
    default:
      return Icons.folder_outlined;
  }
}
