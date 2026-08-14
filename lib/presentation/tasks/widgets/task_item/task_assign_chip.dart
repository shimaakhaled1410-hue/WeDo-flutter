import 'package:flutter/material.dart';
import '../../../../core/extensions/localization_x.dart';
import '../../../../core/theme/app_color_scheme.dart';

class TaskAssignChip extends StatelessWidget {
  const TaskAssignChip({super.key, required this.userImage, required this.userName});

  final String? userImage;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bool hasImage = userImage != null && userImage!.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: colors.primaryLight,
          backgroundImage: hasImage ? NetworkImage(userImage!) : null,
          child: hasImage ? null : Icon(Icons.person, size: 13, color: colors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            (userName != null && userName!.isNotEmpty) ? userName! : l10n.assignedMember,
            style: TextStyle(fontSize: 12, color: colors.textLight, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}