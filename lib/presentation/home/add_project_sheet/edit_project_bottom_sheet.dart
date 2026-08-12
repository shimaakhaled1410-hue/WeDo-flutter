import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/core/widgets/project_icon_helper.dart';
import 'package:wedo_flutter/presentation/manager/project/project_cubit.dart';
import 'widgets/create_project_button.dart';
import 'widgets/project_icon_picker.dart';
import 'widgets/project_name_field.dart';
import 'widgets/sheet_drag_handle.dart';

class EditProjectBottomSheet extends StatefulWidget {
  const EditProjectBottomSheet({super.key, required this.project});

  final ProjectEntity project;

  @override
  State<EditProjectBottomSheet> createState() =>
      _EditProjectBottomSheetState();
}

class _EditProjectBottomSheetState extends State<EditProjectBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late int _selectedIconIndex;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _selectedIconIndex = availableProjectIcons.indexWhere(
      (icon) => icon.codePoint == widget.project.iconCodePoint,
    );
    if (_selectedIconIndex == -1) _selectedIconIndex = 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedProject = widget.project.copyWith(
      name: _nameController.text.trim(),
      iconCodePoint: availableProjectIcons[_selectedIconIndex].codePoint,
    );

    context.read<ProjectCubit>().updateProject(updatedProject);
    context.pop();
    CustomSnackBar.show(
      context: context,
      message: 'Project updated successfully',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Edit Project',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Update the name or icon of your project.',
                style: TextStyle(color: AppColors.textLight, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ProjectNameField(
                controller: _nameController,
                enabled: !_isSaving,
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
                icons: availableProjectIcons,
                selectedIndex: _selectedIconIndex,
                enabled: !_isSaving,
                onSelected: (index) {
                  setState(() => _selectedIconIndex = index);
                },
              ),
              const SizedBox(height: 32),
              CreateProjectButton(
                isLoading: _isSaving,
                onPressed: _submit,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}