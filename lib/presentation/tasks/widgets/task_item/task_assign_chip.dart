import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class TaskAssignChip extends StatelessWidget {
  const TaskAssignChip({
    super.key,
    required this.userImage,
    required this.userName,
  });

  final String? userImage;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = userImage != null && userImage!.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.primaryLight,
          backgroundImage: hasImage ? NetworkImage(userImage!) : null,
          child: hasImage
              ? null
              : const Icon(Icons.person, size: 13, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            (userName != null && userName!.isNotEmpty)
                ? userName!
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
    );
  }
}