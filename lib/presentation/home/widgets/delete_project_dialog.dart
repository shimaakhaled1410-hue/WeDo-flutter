import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../domain/entities/project_entity.dart';
import '../../manager/project/project_cubit.dart';

Future<void> showDeleteProjectDialog(
  BuildContext context,
  ProjectEntity project,
) {
  final projectCubit = context.read<ProjectCubit>();
  final colors = context.colors;
  final l10n = context.l10n;

  return showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: colors.softShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: colors.error,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.deleteProjectTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: colors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.deleteProjectConfirm(project.name),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colors.textLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: colors.surfaceMuted,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: colors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      projectCubit.deleteProject(project.id);
                      Navigator.of(dialogContext).pop();
                      CustomSnackBar.show(
                        context: context,
                        message: l10n.projectDeleted(project.name),
                        isError: false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.error,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      l10n.delete,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
