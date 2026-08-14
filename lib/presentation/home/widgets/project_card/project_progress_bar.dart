import 'package:flutter/material.dart';
import '../../../../core/extensions/localization_x.dart';
import '../../../../core/theme/app_color_scheme.dart';

class ProjectProgressBar extends StatelessWidget {
  const ProjectProgressBar({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  final int completedTasks;
  final int totalTasks;

  double get _progress => totalTasks == 0 ? 0 : completedTasks / totalTasks;
  bool get _hasStarted => completedTasks > 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.tasksCount(completedTasks, totalTasks),
              style: TextStyle(
                color: colors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _hasStarted ? '${(_progress * 100).round()}%' : l10n.notStarted,
              style: TextStyle(
                color: _hasStarted ? colors.primary : colors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border, width: 1),
              ),
            ),
            if (_hasStarted)
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress.clamp(0.04, 1),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: colors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}