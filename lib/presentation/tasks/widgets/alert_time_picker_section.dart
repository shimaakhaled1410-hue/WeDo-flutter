import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class AlertTimePickerSection extends StatelessWidget {
  const AlertTimePickerSection({
    super.key,
    required this.selectedAlertTime,
    required this.onTimeSelected,
  });

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
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        onTimeSelected(
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
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _pickAlertTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _hasAlert ? AppColors.primaryLight : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hasAlert ? AppColors.primary.withValues(alpha: 0.25) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: _hasAlert ? AppColors.primary : AppColors.textLight,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                !_hasAlert
                    ? 'Set Alert Time'
                    : 'Alert: ${selectedAlertTime!.day}/${selectedAlertTime!.month} · '
                        '${selectedAlertTime!.hour}:${selectedAlertTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 14,
                  color: _hasAlert ? AppColors.primary : AppColors.textLight,
                  fontWeight: _hasAlert ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (_hasAlert)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTimeSelected(null),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, color: AppColors.error, size: 18),
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}