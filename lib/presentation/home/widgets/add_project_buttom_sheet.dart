import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';

class AddProjectBottomSheet extends StatefulWidget {
  const AddProjectBottomSheet({super.key});

  @override
  State createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final List _availableIcons = [
    Icons.folder_outlined,
    Icons.shopping_cart_outlined,
    Icons.code_rounded,
    Icons.flight_takeoff_rounded,
    Icons.work_outline_rounded,
    Icons.favorite_border_rounded,
  ];

  int _selectedIconIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is AddProjectSuccess) {
          context.pop();
          CustomSnackBar.show(
            context: context,
            message: 'Project created successfully!',
            isError: false,
          );
        } else if (state is AddProjectError) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddProjectLoading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Project',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: 'Project Name (e.g. Groceries)',
                      hintStyle: const TextStyle(color: AppColors.textLight),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Icon',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableIcons.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _selectedIconIndex;
                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _selectedIconIndex = index;
                                  });
                                },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _availableIcons[index],
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ProjectCubit>().createProject(
                                  name: _nameController.text.trim(),
                                  iconCodePoint:
                                      _availableIcons[_selectedIconIndex]
                                          .codePoint,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : const Text(
                              'Create Project',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
