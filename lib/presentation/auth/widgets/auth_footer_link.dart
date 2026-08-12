import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  final String leadingText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: leadingText,
          style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          children: [
            TextSpan(
              text: actionText,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}