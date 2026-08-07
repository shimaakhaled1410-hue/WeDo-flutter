import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
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
        scrolledUnderElevation: 0,
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
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
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
                        onTap: () async {
                          await context.push(
                            AppRoutes.projectDetails,
                            extra: project,
                          );
                          if (context.mounted) {
                            context.read<ProjectCubit>().fetchProjects();
                          }
                        },
                        onEdit: () {
                          _showEditProjectBottomSheet(context, project);
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Project'),
                              content: Text(
                                'Are you sure you want to delete "${project.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => dialogContext.pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<ProjectCubit>().deleteProject(
                                      project.id,
                                    );
                                    dialogContext.pop();
                                    CustomSnackBar.show(
                                      context: context,
                                      message:
                                          'Project "${project.name}" deleted',
                                      isError: false,
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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

void _showEditProjectBottomSheet(BuildContext context, ProjectEntity project) {
  final projectCubit = context.read<ProjectCubit>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: project.name);

  int selectedIconIndex = _availableIcons.indexWhere(
    (icon) => icon.codePoint == project.iconCodePoint,
  );
  if (selectedIconIndex == -1) selectedIconIndex = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: projectCubit,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Project',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Project Name',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter project name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Icon',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableIcons.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = selectedIconIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIconIndex = index;
                              });
                            },
                            child: Container(
                              width: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _availableIcons[index],
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final updatedProject = project.copyWith(
                              name: nameController.text.trim(),
                              iconCodePoint:
                                  _availableIcons[selectedIconIndex].codePoint,
                            );

                            projectCubit.updateProject(updatedProject);
                            sheetContext.pop();
                            CustomSnackBar.show(
                              context: context,
                              message: 'Project updated successfully',
                              isError: false,
                            );
                          }
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

final List<IconData> _availableIcons = [
  Icons.shopping_cart_outlined,
  Icons.code_rounded,
  Icons.flight_takeoff_rounded,
  Icons.work_outline_rounded,
  Icons.favorite_border_rounded,
];
