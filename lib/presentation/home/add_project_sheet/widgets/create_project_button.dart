import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class CreateProjectButton extends StatelessWidget {
  const CreateProjectButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading ? null : AppColors.primaryGradient,
          color: isLoading ? AppColors.textMuted : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading ? null : AppColors.softShadow,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : const Text(
                  'Create Project',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}