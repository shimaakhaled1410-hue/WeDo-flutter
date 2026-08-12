import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class ProjectIconPicker extends StatelessWidget {
  const ProjectIconPicker({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.enabled,
    required this.onSelected,
  });

  final List<IconData> icons;
  final int selectedIndex;
  final bool enabled;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: enabled ? () => onSelected(index) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 12),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.border,
                ),
                boxShadow: isSelected ? AppColors.softShadow : null,
              ),
              child: Icon(
                icons[index],
                color: isSelected ? AppColors.white : AppColors.textLight,
                size: 22,
              ),
            ),
          );
        },
      ),
    );
  }
}