import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_state.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/add_task_buttom_sheet.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/animated_segmanted_control.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/edit_task_dialog.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/task_item/task_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.project.name,
          style: const TextStyle(
            color: AppColors.textDark,
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
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.cardShadow,
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              tooltip: 'Invite Collaborator',
              onPressed: () {
                final inviteUrl = 'wedo://join?projectId=${widget.project.id}';
                Clipboard.setData(ClipboardData(text: inviteUrl));
                CustomSnackBar.show(
                  context: context,
                  message: 'Invite link copied to clipboard!',
                );
              },
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
                  options: const ['All', 'My Tasks', 'Pending', 'Done'],
                  onOptionSelected: (index) {
                    cubit.changeFilter(TaskFilter.values[index]);
                  },
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
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }
                  if (state is GetTasksError && cubit.tasksList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
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
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.task_alt_rounded,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No tasks found',
                            style: TextStyle(
                              color: AppColors.textDark,
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
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.accentShadow,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => _showAddTaskBottomSheet(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.add_rounded, color: AppColors.white),
        ),
      ),
    );
  }
}