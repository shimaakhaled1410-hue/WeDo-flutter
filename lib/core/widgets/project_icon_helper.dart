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

/// Maps a stored icon codePoint back to its IconData for display.
IconData getProjectIcon(int codePoint) {
  switch (codePoint) {
    case 0xe59c: // Icons.shopping_cart_outlined
      return Icons.shopping_cart_outlined;
    case 0xe190: // Icons.code_rounded
      return Icons.code_rounded;
    case 0xe293: // Icons.flight_takeoff_rounded
      return Icons.flight_takeoff_rounded;
    case 0xe6e0: // Icons.work_outline_rounded
      return Icons.work_outline_rounded;
    case 0xe25b: // Icons.favorite_border_rounded
      return Icons.favorite_border_rounded;
    default:
      return Icons.folder_outlined;
  }
}