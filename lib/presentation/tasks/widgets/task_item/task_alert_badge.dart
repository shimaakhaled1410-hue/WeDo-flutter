import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';

class TaskAlertBadge extends StatelessWidget {
  const TaskAlertBadge({super.key, required this.alertTime, required this.isCompleted});

  final DateTime alertTime;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Color color = isCompleted ? colors.textMuted : colors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? colors.surfaceMuted : colors.accentLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_active_outlined, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            '${alertTime.day}/${alertTime.month} · ${alertTime.hour}:${alertTime.minute.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}