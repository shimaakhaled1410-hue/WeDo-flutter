import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/extensions/localization_x.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../domain/entities/project_entity.dart';
import '../manager/tasks/task_cubit.dart';
import '../manager/tasks/task_state.dart';
import '../tasks/widgets/add_task_buttom_sheet.dart';
import '../tasks/widgets/animated_segmanted_control.dart';
import '../tasks/widgets/edit_task_dialog.dart';
import '../tasks/widgets/task_item/task_item.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key, required this.project});

  final ProjectEntity project;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _showAddTaskBottomSheet(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: taskCubit,
        child: AddTaskBottomSheet(project: widget.project),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, dynamic task) {
    final taskCubit = context.read<TaskCubit>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: taskCubit,
        child: EditTaskDialog(task: task),
      ),
    );
  }

  void _shareInviteLink(BuildContext context) {
    final l10n = context.l10n;
    final inviteUrl =
        'https://naslookapp-ecf15.web.app/join?projectId=${widget.project.id}';
    final shareText = l10n.inviteShareMessage(widget.project.name, inviteUrl);

    SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: colors.cardShadow,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.primary,
              size: 16,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.project.name,
          style: TextStyle(
            color: colors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: colors.cardShadow,
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: colors.primary,
                  size: 18,
                ),
              ),
              tooltip: l10n.inviteCollaborator,
              onPressed: () => _shareInviteLink(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                final cubit = context.read<TaskCubit>();
                return AnimatedSegmentedControl(
                  selectedIndex: cubit.currentFilter.index,
                  options: [
                    l10n.filterAll,
                    l10n.filterMyTasks,
                    l10n.filterPending,
                    l10n.filterDone,
                  ],
                  onOptionSelected: (index) =>
                      cubit.changeFilter(TaskFilter.values[index]),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  final cubit = context.read<TaskCubit>();
                  final displayList = cubit.filteredTasks;

                  if (state is GetTasksLoading && cubit.tasksList.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }
                  if (state is GetTasksError && cubit.tasksList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: colors.error),
                      ),
                    );
                  }
                  if (displayList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: colors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.task_alt_rounded,
                              color: colors.primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.noTasksFound,
                            style: TextStyle(
                              color: colors.textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: displayList.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final task = displayList[index];
                      return TaskItem(
                        task: task,
                        currentUserId: currentUserId,
                        projectOwnerId: widget.project.ownerId,
                        onEditTap: () => _showEditTaskDialog(context, task),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.accentGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: colors.accentShadow,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => _showAddTaskBottomSheet(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
