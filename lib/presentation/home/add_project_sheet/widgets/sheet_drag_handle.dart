import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';

class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Container(
        width: 42,
        height: 4,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: colors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
