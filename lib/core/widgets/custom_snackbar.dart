import 'package:flutter/material.dart';
import '../theme/app_color_scheme.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    final colors = context.colors;
    final Color accentColor = isError ? colors.error : colors.success;
    final Color accentBg = isError ? colors.errorLight : colors.successLight;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
            boxShadow: colors.softShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   isError ? 'Oops!' : 'Success!',
                    //   style: TextStyle(
                    //     color: accentColor,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    // const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: colors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}