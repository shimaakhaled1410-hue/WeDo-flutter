import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../../domain/entities/app_locale.dart';
import '../../manager/locale/locale_cubit.dart';
import '../../manager/locale/locale_state.dart';

Future<void> showLanguageSheet(BuildContext context) {
  final localeCubit = context.read<LocaleCubit>();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: localeCubit,
      child: const _LanguageSheet(),
    ),
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                l10n.chooseLanguage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _LanguageOptionTile(
                locale: AppLocale.english,
                label: l10n.languageEnglish,
                flagEmoji: '🇬🇧',
                isSelected: state.locale == AppLocale.english,
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(AppLocale.english);
                  Navigator.of(context).pop();
                },
              ),
              _LanguageOptionTile(
                locale: AppLocale.arabic,
                label: l10n.languageArabic,
                flagEmoji: '🇪🇬',
                isSelected: state.locale == AppLocale.arabic,
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(AppLocale.arabic);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.locale,
    required this.label,
    required this.flagEmoji,
    required this.isSelected,
    required this.onTap,
  });

  final AppLocale locale;
  final String label;
  final String flagEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryLight : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Row(
          children: [
            Text(flagEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? colors.primary : colors.textDark,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}