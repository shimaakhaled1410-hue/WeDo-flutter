import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
import '../../../core/extensions/localization_x.dart';

class NotificationEmptyView extends StatelessWidget {
  const NotificationEmptyView({super.key, required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return RefreshIndicator(
      color: colors.primary,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: colors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_off_outlined,
                          color: colors.primary,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.noNotificationsYet,
                        style: TextStyle(
                          color: colors.textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.notificationsEmptyHint,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.textLight,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
