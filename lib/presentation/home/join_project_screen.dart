import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';

class JoinProjectScreen extends StatefulWidget {
  final String? projectId;

  const JoinProjectScreen({super.key, required this.projectId});

  @override
  State<JoinProjectScreen> createState() => _JoinProjectScreenState();
}

class _JoinProjectScreenState extends State<JoinProjectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleJoin());
  }

  void _handleJoin() {
    final projectId = widget.projectId;
    if (projectId == null || projectId.isEmpty) {
      context.go(AppRoutes.home);
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      context.go('${AppRoutes.login}?redirectProjectId=$projectId');
      return;
    }

    context.read<ProjectCubit>().joinProjectById(projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProjectCubit, ProjectState>(
        listener: (context, state) {
          if (state is ProjectJoinedSuccess) {
            CustomSnackBar.show(
              context: context,
              message: "Joined project successfully!",
            );
            context.go(AppRoutes.home);
          } else if (state is JoinProjectError) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              isError: true,
            );
            context.go(AppRoutes.home);
          }
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Joining project...'),
            ],
          ),
        ),
      ),
    );
  }
}