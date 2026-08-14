import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';

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
    final colors = context.colors;

    return SizedBox(
      height: 26,
      width: 26,
      child: Checkbox(
        value: value,
        activeColor: colors.accent,
        checkColor: Colors.white,
        side: BorderSide(color: colors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
