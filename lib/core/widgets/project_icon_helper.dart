import 'package:flutter/material.dart';

/// Icons available for a project, shared between create & edit flows.
const List<IconData> availableProjectIcons = [
  Icons.folder_outlined,
  Icons.shopping_cart_outlined,
  Icons.code_rounded,
  Icons.flight_takeoff_rounded,
  Icons.work_outline_rounded,
  Icons.favorite_border_rounded,
];
IconData getProjectIcon(int index) {
  if (index < 0 || index >= availableProjectIcons.length) {
    return availableProjectIcons.first;
  }
  return availableProjectIcons[index];
}