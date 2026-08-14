import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../manager/project/project_cubit.dart';
import '../../manager/project/project_state.dart';

class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.primaryGradient.createShader(bounds),
          child: Text(
            l10n.myLists,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        BlocBuilder<ProjectCubit, ProjectState>(
          builder: (context, state) {
            final count = context.read<ProjectCubit>().projectsList.length;
            return Text(
              l10n.activeProjectsCount(count),
              style: TextStyle(
                color: colors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ],
    );
  }
}
