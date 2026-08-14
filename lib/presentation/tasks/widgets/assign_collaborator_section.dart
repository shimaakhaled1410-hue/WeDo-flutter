import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/extensions/localization_x.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';


class AssignCollaboratorSection extends StatelessWidget {
  const AssignCollaboratorSection({super.key, required this.project, required this.selectedUserId, required this.onAssign});

  final ProjectEntity project;
  final String? selectedUserId;
  final Function(String? userId, String? userImage, String? userName) onAssign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Text(l10n.assignTo, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: colors.textDark)),
            Text(' *', style: TextStyle(color: colors.error, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: project.collaboratorsIds.length,
          itemBuilder: (context, index) {
            final collabId = project.collaboratorsIds[index];
            final collabImage = (project.collaboratorsImages.isNotEmpty && project.collaboratorsImages.length > index)
                ? project.collaboratorsImages[index]
                : '';
            final namesList = project.collaboratorsNames;
            final collabName = (namesList.isNotEmpty && namesList.length > index) ? namesList[index] : l10n.member;
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

class _CollaboratorTile extends StatelessWidget {
  const _CollaboratorTile({super.key, required this.isSelected, required this.collabImage, required this.collabName, required this.onTap});

  final bool isSelected;
  final String collabImage;
  final String collabName;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 220);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryLight : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? colors.primary : colors.border, width: isSelected ? 1.5 : 1),
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
                border: Border.all(color: isSelected ? colors.primary : Colors.transparent, width: 2),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: colors.surface,
                backgroundImage: collabImage.isNotEmpty ? NetworkImage(collabImage) : null,
                child: collabImage.isEmpty ? Icon(Icons.person, size: 16, color: colors.textMuted) : null,
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
                  color: isSelected ? colors.primary : colors.textDark,
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
                child: Icon(Icons.check_circle_rounded, color: colors.primary, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}