import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/task_item/task_assign_chip.dart';
import 'task_alert_badge.dart';
import 'task_checkbox.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.currentUserId,
    required this.projectOwnerId,
    required this.onEditTap,
  });

  final TaskEntity task;
  final String currentUserId;
  final String projectOwnerId;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    final canDelete = task.canDelete(currentUserId, projectOwnerId);
    final canEdit = task.canEditTitle(currentUserId);
    final canToggle = task.canToggleCompletion(currentUserId);
    final hasAssignee = task.assignedToUserId != null;

    return Dismissible(
      key: Key(task.id),
      direction:
          canDelete ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.white),
      ),
      onDismissed: (_) {
        context.read<TaskCubit>().deleteTask(task);
        CustomSnackBar.show(
          context: context,
          message: 'Task "${task.title}" deleted',
          isError: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskCheckbox(
                  value: task.isCompleted,
                  enabled: canToggle,
                  onChanged: (_) => context.read<TaskCubit>().toggleTask(task),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                ),
                if (canEdit)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: onEditTap,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            if (hasAssignee || task.alertTime != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (hasAssignee)
                      TaskAssignChip(
                        userImage: task.assignedToUserImage,
                        userName: task.assignedToUserName,
                      ),
                    if (task.alertTime != null)
                      TaskAlertBadge(
                        alertTime: task.alertTime!,
                        isCompleted: task.isCompleted,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}