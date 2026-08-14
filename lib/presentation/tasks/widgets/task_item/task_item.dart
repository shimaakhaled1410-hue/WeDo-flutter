import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/presentation/tasks/widgets/task_item/task_assign_chip.dart';
import '../../../../core/extensions/localization_x.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../domain/entities/task_entity.dart';
import '../../../manager/tasks/task_cubit.dart';
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
    final colors = context.colors;
    final l10n = context.l10n;

    final canDelete = task.canDelete(currentUserId, projectOwnerId);
    final canEdit = task.canEditTitle(currentUserId);
    final canToggle = task.canToggleCompletion(currentUserId);
    final hasAssignee = task.assignedToUserId != null;

    return Dismissible(
      key: Key(task.id),
      direction: canDelete ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: colors.error, borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TaskCubit>().deleteTask(task);
        CustomSnackBar.show(context: context, message: l10n.taskDeleted(task.title), isError: false);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border),
          boxShadow: colors.cardShadow,
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
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? colors.textMuted : colors.textDark,
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
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.edit_outlined, size: 17, color: colors.textMuted),
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
                      TaskAssignChip(userImage: task.assignedToUserImage, userName: task.assignedToUserName),
                    if (task.alertTime != null)
                      TaskAlertBadge(alertTime: task.alertTime!, isCompleted: task.isCompleted),
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