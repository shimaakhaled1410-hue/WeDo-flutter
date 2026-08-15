import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/extensions/localization_x.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';

class DueDatePickerSection extends StatelessWidget {
  const DueDatePickerSection({
    super.key,
    required this.selectedDueDate,
    required this.onDateSelected,
  });

  final DateTime? selectedDueDate;
  final Function(DateTime? date) onDateSelected;

  bool get _hasDueDate => selectedDueDate != null;

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        onDateSelected(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final String label = !_hasDueDate
        ? l10n.setDueDate
        : l10n.dueDateLabel(
            '${selectedDueDate!.day}/${selectedDueDate!.month}',
            '${selectedDueDate!.hour}:${selectedDueDate!.minute.toString().padLeft(2, '0')}',
          );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _pickDueDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _hasDueDate ? colors.errorLight : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasDueDate
                ? colors.error.withValues(alpha: 0.25)
                : colors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_busy_rounded,
              color: _hasDueDate ? colors.error : colors.textLight,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: _hasDueDate ? colors.error : colors.textLight,
                  fontWeight: _hasDueDate ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (_hasDueDate)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onDateSelected(null),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    color: colors.error,
                    size: 18,
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: colors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
