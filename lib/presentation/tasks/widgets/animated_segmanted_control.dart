import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class AnimatedSegmentedControl extends StatelessWidget {
  const AnimatedSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.options,
    required this.onOptionSelected,
  });

  final int selectedIndex;
  final List<String> options;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment(
              -1.0 + (selectedIndex * (2.0 / (options.length - 1))),
              0.0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1.0 / options.length,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: AppColors.softShadow,
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onOptionSelected(index),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textLight,
                      ),
                      child: Text(options[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}