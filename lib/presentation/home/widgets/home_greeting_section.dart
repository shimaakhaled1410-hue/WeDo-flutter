import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';

class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'My Lists',
            style: TextStyle(
              color: AppColors.white, // masked by the gradient
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
              'You have $count active project${count == 1 ? '' : 's'}',
              style: const TextStyle(
                color: AppColors.textLight,
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