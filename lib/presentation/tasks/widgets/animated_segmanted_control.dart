import 'package:flutter/material.dart';
import '../../../core/theme/app_color_scheme.dart';

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
    final colors = context.colors;

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: AlignmentDirectional(
              -1.0 + (selectedIndex * (2.0 / (options.length - 1))),
              0.0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1.0 / options.length,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: colors.softShadow,
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
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : colors.textLight,
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
