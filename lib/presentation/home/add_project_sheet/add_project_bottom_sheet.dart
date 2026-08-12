import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'package:wedo_flutter/presentation/manager/project/project_state.dart';
import 'widgets/create_project_button.dart';
import 'widgets/project_icon_picker.dart';
import 'widgets/project_name_field.dart';
import 'widgets/sheet_drag_handle.dart';

class AddProjectBottomSheet extends StatefulWidget {
  const AddProjectBottomSheet({super.key});

  @override
  State<AddProjectBottomSheet> createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final List<IconData> _availableIcons = const [
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProjectCubit>().createProject(
            name: _nameController.text.trim(),
            iconCodePoint: _availableIcons[_selectedIconIndex].codePoint,
          );
    }
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
        final bool isLoading = state is AddProjectLoading;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SheetDragHandle(),
                  const Text(
                    'Create New Project',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Give your project a name and pick an icon.',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ProjectNameField(
                    controller: _nameController,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Icon',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProjectIconPicker(
                    icons: _availableIcons,
                    selectedIndex: _selectedIconIndex,
                    enabled: !isLoading,
                    onSelected: (index) {
                      setState(() => _selectedIconIndex = index);
                    },
                  ),
                  const SizedBox(height: 32),
                  CreateProjectButton(
                    isLoading: isLoading,
                    onPressed: _submit,
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