import 'package:flutter/material.dart';
import '../../../core/theme/app_color_scheme.dart';

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
    final colors = context.colors;

    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => colors.heroGradient.createShader(bounds),
          child: const Text(
            'WeDo',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: Colors.white, // masked
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          heading,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subheading,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, color: colors.textLight),
        ),
      ],
    );
  }
}
