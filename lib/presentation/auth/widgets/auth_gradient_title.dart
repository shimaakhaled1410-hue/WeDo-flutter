import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthGradientTitle extends StatelessWidget {
  const AuthGradientTitle({
    super.key,
    required this.heading,
    required this.subheading,
  });

  final String heading;
  final String subheading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.heroGradient.createShader(bounds),
          child: const Text(
            'WeDo',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.white, // masked
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          heading,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subheading,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textLight),
        ),
      ],
    );
  }
}
