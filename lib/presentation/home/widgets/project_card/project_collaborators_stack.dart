import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';

class ProjectCollaboratorsStack extends StatelessWidget {
  const ProjectCollaboratorsStack({super.key, required this.imageUrls});

  final List<String> imageUrls;

  static const int _maxVisible = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final int visibleCount = imageUrls.length > _maxVisible
        ? _maxVisible + 1
        : imageUrls.length;

    return SizedBox(
      height: 32,
      child: Row(
        children: List.generate(visibleCount, (index) {
          final bool isOverflowBadge =
              imageUrls.length > _maxVisible && index == _maxVisible;

          if (isOverflowBadge) {
            final remaining = imageUrls.length - _maxVisible;
            return Align(
              widthFactor: 0.65,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: colors.primary,
                child: Text(
                  '+$remaining',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          final imageUrl = imageUrls[index];

          return Align(
            widthFactor: 0.65,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: colors.surface,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: colors.surfaceMuted,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 14, color: colors.textMuted)
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
