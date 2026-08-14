import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class NotificationIconBadge extends StatelessWidget {
  const NotificationIconBadge({super.key, required this.unread});

  final bool unread;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: unread ? AppColors.primaryGradient : null,
        color: unread ? null : colors.surfaceMuted,
        shape: BoxShape.circle,
        boxShadow: unread ? AppColors.softShadow : null,
      ),
      child: Icon(
        unread
            ? Icons.notifications_active_rounded
            : Icons.notifications_none_rounded,
        color: unread ? Colors.white : colors.textLight,
        size: 20,
      ),
    );
  }
}
