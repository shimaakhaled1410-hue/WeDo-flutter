import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../../domain/entities/app_locale.dart';
import '../../manager/locale/locale_cubit.dart';
import '../../manager/locale/locale_state.dart';
import '../../profile/widgets/language_bottom_sheet.dart';


class AuthLanguageToggle extends StatelessWidget {
  const AuthLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final label =
            state.locale == AppLocale.arabic ? 'العربية' : 'English';

        return InkWell(
          onTap: () => showLanguageSheet(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
              boxShadow: colors.cardShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded, size: 15, color: colors.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: colors.textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}