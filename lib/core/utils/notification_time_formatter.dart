import 'package:flutter/material.dart';
import '../extensions/localization_x.dart';

extension NotificationTimeFormatter on DateTime {
  String toRelativeLabel(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) {
      return l10n.justNow;
    } else if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours);
    } else if (diff.inDays == 1) {
      return l10n.yesterday;
    } else {
      return l10n.daysAgo(diff.inDays);
    }
  }
}