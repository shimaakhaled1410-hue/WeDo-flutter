import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completedTasks/$totalTasks tasks',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _hasStarted ? '${(_progress * 100).round()}%' : 'Not started',
              style: TextStyle(
                color: _hasStarted ? AppColors.primary : AppColors.textMuted,
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
            // Track — always visible with a border so it never disappears.
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
            // Fill — only rendered once there's real progress.
            if (_hasStarted)
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress.clamp(0.04, 1),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.35),
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