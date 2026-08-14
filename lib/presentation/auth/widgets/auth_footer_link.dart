import 'package:flutter/material.dart';
import '../../../core/theme/app_color_scheme.dart';

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
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: leadingText,
          style: TextStyle(color: colors.textLight, fontSize: 14),
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
