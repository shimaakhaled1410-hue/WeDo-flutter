import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class AlertTimePickerSection extends StatelessWidget {
  final DateTime? selectedAlertTime;
  final Function(DateTime? time) onTimeSelected;

  const AlertTimePickerSection({
    super.key,
    required this.selectedAlertTime,
    required this.onTimeSelected,
  });

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
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(
          Icons.notifications_active_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          selectedAlertTime == null
              ? 'Set Alert Time'
              : 'Alert: ${selectedAlertTime!.day}/${selectedAlertTime!.month} - ${selectedAlertTime!.hour}:${selectedAlertTime!.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: selectedAlertTime == null
                ? AppColors.textLight
                : AppColors.primary,
            fontWeight: selectedAlertTime == null
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        trailing: selectedAlertTime != null
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.red, size: 20),
                onPressed: () => onTimeSelected(null),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _pickAlertTime(context),
      ),
    );
  }
}
