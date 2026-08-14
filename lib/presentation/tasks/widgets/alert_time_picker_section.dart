import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/extensions/localization_x.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';


class AlertTimePickerSection extends StatelessWidget {
  const AlertTimePickerSection({super.key, required this.selectedAlertTime, required this.onTimeSelected});

  final DateTime? selectedAlertTime;
  final Function(DateTime? time) onTimeSelected;

  bool get _hasAlert => selectedAlertTime != null;

  Future<void> _pickAlertTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && context.mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        onTimeSelected(
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final String label = !_hasAlert
        ? l10n.setAlertTime
        : l10n.alertLabel(
            '${selectedAlertTime!.day}/${selectedAlertTime!.month}',
            '${selectedAlertTime!.hour}:${selectedAlertTime!.minute.toString().padLeft(2, '0')}',
          );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _pickAlertTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _hasAlert ? colors.primaryLight : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _hasAlert ? colors.primary.withValues(alpha: 0.25) : colors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_active_outlined, color: _hasAlert ? colors.primary : colors.textLight, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: _hasAlert ? colors.primary : colors.textLight,
                  fontWeight: _hasAlert ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (_hasAlert)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTimeSelected(null),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, color: colors.error, size: 18),
                ),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}