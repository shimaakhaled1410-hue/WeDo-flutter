import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/widgets/project_icon_helper.dart';
import '../../core/extensions/localization_x.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_color_scheme.dart';
import 'add_project_sheet/add_project_bottom_sheet.dart';
import 'add_project_sheet/edit_project_bottom_sheet.dart';
import 'widgets/delete_project_dialog.dart';
import 'widgets/home_greeting_section.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/project_card/project_card.dart';
import '../manager/project/project_cubit.dart';
import '../manager/project/project_state.dart';

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
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeTopBar(),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: HomeGreetingSection(),
            ),
            Expanded(
              child: BlocBuilder<ProjectCubit, ProjectState>(
                builder: (context, state) {
                  final cubit = context.read<ProjectCubit>();

                  if (state is GetProjectsLoading &&
                      cubit.projectsList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }

                  if (state is GetProjectsError && cubit.projectsList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: colors.error),
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
                              decoration: BoxDecoration(
                                gradient: colors.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.folder_open_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.noProjectsYet,
                              style: TextStyle(
                                color: colors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.tapAddToCreate,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.textLight,
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
              gradient: colors.accentGradient,
              shape: BoxShape.circle,
              boxShadow: colors.accentShadow,
            ),
            child: FloatingActionButton(
              onPressed: () => _openAddProjectSheet(buttonContext),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}
