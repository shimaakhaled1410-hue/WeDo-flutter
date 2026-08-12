import 'package:flutter/material.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';

class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}