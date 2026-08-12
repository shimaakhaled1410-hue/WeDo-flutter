import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProjectCardHeader extends StatelessWidget {
  const ProjectCardHeader({
    super.key,
    required this.icon,
    this.onEdit,
    this.onDelete,
  });

  final IconData icon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.softShadow,
          ),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        _ActionsMenu(onEdit: onEdit, onDelete: onDelete),
      ],
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu({this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_horiz_rounded,
          color: AppColors.textLight,
          size: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 4,
        color: AppColors.surface,
        onSelected: (value) {
          if (value == 'edit') {
            onEdit?.call();
          } else if (value == 'delete') {
            onDelete?.call();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                const SizedBox(width: 10),
                const Text(
                  'Delete',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}