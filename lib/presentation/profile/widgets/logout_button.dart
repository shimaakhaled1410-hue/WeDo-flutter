import 'package:flutter/material.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.errorLight,
          side: BorderSide(color: colors.error.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        icon: Icon(Icons.logout_rounded, color: colors.error, size: 19),
        label: Text(
          l10n.signOut,
          style: TextStyle(
            color: colors.error,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
