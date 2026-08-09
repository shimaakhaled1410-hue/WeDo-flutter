import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskEntity task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit Task'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter new task title',
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textLight),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final newTitle = _controller.text.trim();
            if (newTitle.isNotEmpty) {
              context.read<TaskCubit>().updateTask(widget.task, newTitle);
              context.pop();
              CustomSnackBar.show(
                context: context,
                message: 'Task updated successfully',
                isError: false,
              );
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
