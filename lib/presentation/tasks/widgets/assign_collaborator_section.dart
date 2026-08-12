import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';

class AssignCollaboratorSection extends StatelessWidget {
  const AssignCollaboratorSection({
    super.key,
    required this.project,
    required this.selectedUserId,
    required this.onAssign,
  });

  final ProjectEntity project;
  final String? selectedUserId;
  final Function(String? userId, String? userImage, String? userName) onAssign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              'Assign to',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
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

            return _CollaboratorTile(
              key: ValueKey(collabId),
              isSelected: isSelected,
              collabImage: collabImage,
              collabName: collabName,
              onTap: () => isSelected
                  ? onAssign(null, null, null)
                  : onAssign(collabId, collabImage, collabName),
            );
          },
        ),
      ],
    );
  }
}

/// Extracted as its own widget so only the tapped tile rebuilds/animates,
/// keeping the animation smooth and cheap even with many collaborators.
class _CollaboratorTile extends StatelessWidget {
  const _CollaboratorTile({
    super.key,
    required this.isSelected,
    required this.collabImage,
    required this.collabName,
    required this.onTap,
  });

  final bool isSelected;
  final String collabImage;
  final String collabName;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 220);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: _duration,
              curve: _curve,
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surface,
                backgroundImage:
                    collabImage.isNotEmpty ? NetworkImage(collabImage) : null,
                child: collabImage.isEmpty
                    ? const Icon(Icons.person, size: 16, color: AppColors.textMuted)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: _duration,
                curve: _curve,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textDark,
                ),
                child: Text(collabName),
              ),
            ),
            AnimatedScale(
              duration: _duration,
              curve: Curves.easeOutBack,
              scale: isSelected ? 1 : 0,
              child: AnimatedOpacity(
                duration: _duration,
                opacity: isSelected ? 1 : 0,
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}