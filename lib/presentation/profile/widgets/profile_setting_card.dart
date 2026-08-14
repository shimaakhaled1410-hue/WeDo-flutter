import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/entities/app_theme_mode.dart';
import 'package:wedo_flutter/presentation/profile/widgets/profile_settings_tile.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../manager/locale/locale_cubit.dart';
import '../../manager/locale/locale_state.dart';
import '../../manager/theme/theme_cubit.dart';
import '../../manager/theme/theme_state.dart';
import 'language_bottom_sheet.dart';
import 'theme_mode_bottom_sheet.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: colors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              final label = state.locale.name == 'arabic'
                  ? l10n.languageArabic
                  : l10n.languageEnglish;

              return ProfileSettingsTile(
                icon: Icons.language_rounded,
                title: l10n.language,
                trailingText: label,
                iconBackground: colors.infoLight,
                iconColor: colors.info,
                onTap: () => showLanguageSheet(context),
              );
            },
          ),
          Divider(height: 1, indent: 60, endIndent: 16, color: colors.divider),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return ProfileSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: l10n.themeMode,
                trailingText: state.mode.label,
                iconBackground: colors.primaryLight,
                iconColor: colors.primary,
                onTap: () => showThemeModeSheet(context),
              );
            },
          ),
        ],
      ),
    );
  }
}
