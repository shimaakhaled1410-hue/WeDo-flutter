import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'project_card_header.dart';
import 'project_collaborators_stack.dart';
import 'project_progress_bar.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.completedTasks,
    required this.totalTasks,
    required this.icon,
    required this.collaboratorsImages,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final int completedTasks;
  final int totalTasks;
  final IconData icon;
  final List<String> collaboratorsImages;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectCardHeader(
              icon: icon,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            ProjectProgressBar(
              completedTasks: completedTasks,
              totalTasks: totalTasks,
            ),
            const SizedBox(height: 16),
            ProjectCollaboratorsStack(imageUrls: collaboratorsImages),
          ],
        ),
      ),
    );
  }
}