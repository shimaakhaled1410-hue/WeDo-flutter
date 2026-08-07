import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final int completedTasks;
  final int totalTasks;
  final IconData icon;
  final List<String> collaboratorsImages;

  const ProjectCard({
    super.key,
    required this.title,
    required this.completedTasks,
    required this.totalTasks,
    required this.icon,
    required this.collaboratorsImages,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), 
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const Icon(Icons.more_vert, color: AppColors.textLight, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completedTasks/$totalTasks tasks',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.background.withValues(alpha:0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: List.generate(
              collaboratorsImages.length,
              (index) {
                return Align(
                  widthFactor: 0.7, 
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.white, 
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(collaboratorsImages[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}