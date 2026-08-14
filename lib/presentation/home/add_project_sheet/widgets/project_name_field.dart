import 'package:flutter/material.dart';
import '../../../../core/extensions/localization_x.dart';
import '../../../../core/theme/app_color_scheme.dart';

class ProjectNameField extends StatelessWidget {
  const ProjectNameField({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      style: TextStyle(
        color: colors.textDark,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: l10n.projectNameHint,
        hintStyle: TextStyle(
          color: colors.textMuted,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: colors.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? l10n.projectNameRequired
          : null,
    );
  }
}
