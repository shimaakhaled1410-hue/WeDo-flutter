import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/extensions/localization_x.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/task_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({super.key, required this.task});

  final TaskEntity task;

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

  void _save() {
    final l10n = context.l10n;
    final newTitle = _controller.text.trim();
    if (newTitle.isNotEmpty) {
      context.read<TaskCubit>().updateTask(widget.task, newTitle);
      context.pop();
      CustomSnackBar.show(context: context, message: l10n.taskUpdatedSuccess, isError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(22), boxShadow: colors.softShadow),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: colors.primaryLight, borderRadius: BorderRadius.circular(11)),
                  child: Icon(Icons.edit_outlined, color: colors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Text(l10n.editTask, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: colors.textDark)),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(color: colors.textDark, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: l10n.enterNewTaskTitle,
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: colors.surfaceMuted,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide(color: colors.primary, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      backgroundColor: colors.surfaceMuted,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                    ),
                    child: Text(l10n.cancel, style: TextStyle(color: colors.textLight, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: colors.primaryGradient, borderRadius: BorderRadius.circular(13)),
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                      child: Text(l10n.save, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}