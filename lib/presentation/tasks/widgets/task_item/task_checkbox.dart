import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final bool value;
  final bool enabled;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      width: 26,
      child: Checkbox(
        value: value,
        activeColor: AppColors.accent,
        checkColor: AppColors.white,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}