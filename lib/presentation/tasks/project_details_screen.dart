import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
// import 'package:wedo_flutter/presentation/home/widgets/project_collaborators_bar.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_state.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/add_task_buttom_sheet.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/animated_segmanted_control.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/edit_task_dialog.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/task_item.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectEntity project;

  const ProjectDetailsScreen({super.key, required this.project});

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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.project.name,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: AppColors.primary,
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 12),
            // ProjectCollaboratorsBar(
            //   projectId: widget.project.id,
            //   collaboratorsImages: widget.project.collaboratorsImages,
            // ),
            const SizedBox(height: 16),

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
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (state is GetTasksError && cubit.tasksList.isEmpty) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (displayList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks found.',
                        style: TextStyle(color: AppColors.textLight),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => _showAddTaskBottomSheet(context),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
