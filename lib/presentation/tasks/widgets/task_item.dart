import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';

class TaskItem extends StatelessWidget {
  final TaskEntity task;
  final String currentUserId;
  final String projectOwnerId;
  final VoidCallback onEditTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.currentUserId,
    required this.projectOwnerId,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final canDelete = task.canDelete(currentUserId, projectOwnerId);
    final canEdit = task.canEditTitle(currentUserId);
    final canToggle = task.canToggleCompletion(currentUserId);

    return Dismissible(
      key: Key(task.id),
      direction: canDelete
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
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
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: canToggle
                          ? (_) => context.read<TaskCubit>().toggleTask(task)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? AppColors.textLight
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.assignedToUserId != null)
                            Row(
                              children: [
                                if (task.assignedToUserImage != null &&
                                    task.assignedToUserImage!.isNotEmpty)
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(
                                      task.assignedToUserImage!,
                                    ),
                                  )
                                else
                                  const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.background,
                                    child: Icon(
                                      Icons.person,
                                      size: 14,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    (task.assignedToUserName != null &&
                                            task.assignedToUserName!.isNotEmpty)
                                        ? task.assignedToUserName!
                                        : 'Assigned Member',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                          if (task.alertTime != null) ...[
                            if (task.assignedToUserId != null)
                              const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications_active_outlined,
                                  size: 14,
                                  color: task.isCompleted
                                      ? AppColors.textLight
                                      : AppColors.accent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${task.alertTime!.day}/${task.alertTime!.month} - ${task.alertTime!.hour}:${task.alertTime!.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: task.isCompleted
                                        ? AppColors.textLight
                                        : AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // -- Right Side: Edit Button --
                    if (canEdit)
                      InkWell(
                        onTap: onEditTap,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.textLight,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
