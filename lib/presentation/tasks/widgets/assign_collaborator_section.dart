import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

class AssignCollaboratorSection extends StatelessWidget {
  final ProjectEntity project;
  final String? selectedUserId;
  final Function(String? userId, String? userImage, String? userName) onAssign;

  const AssignCollaboratorSection({
    super.key,
    required this.project,
    required this.selectedUserId,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Row(
          children: [
            Text(
              'Assign to:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: project.collaboratorsIds.length,
          itemBuilder: (context, index) {
            final collabId = project.collaboratorsIds[index];
            final collabImage =
                (project.collaboratorsImages.isNotEmpty &&
                    project.collaboratorsImages.length > index)
                ? project.collaboratorsImages[index]
                : '';
            final namesList = project.collaboratorsNames;
            final collabName =
                (namesList.isNotEmpty && namesList.length > index)
                ? namesList[index]
                : 'Member';
            final isSelected = selectedUserId == collabId;

            return InkWell(
              onTap: () {
                if (isSelected) {
                  onAssign(null, null, null);
                } else {
                  onAssign(collabId, collabImage, collabName);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.white,
                      backgroundImage: collabImage.isNotEmpty
                          ? NetworkImage(collabImage)
                          : null,
                      child: collabImage.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 18,
                              color: AppColors.textLight,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        collabName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.black87,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
