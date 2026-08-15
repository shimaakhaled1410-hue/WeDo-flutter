import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/widgets/project_icon_helper.dart';
import '../../../core/extensions/localization_x.dart';
import '../../../core/theme/app_color_scheme.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../manager/project/project_cubit.dart';
import '../../manager/project/project_state.dart';
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
  int _selectedIconIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is AddProjectSuccess) {
          context.pop();
          CustomSnackBar.show(
            context: context,
            message: l10n.projectCreatedSuccess,
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
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SheetDragHandle(),
                  Text(
                    l10n.createProject,
                    style: TextStyle(
                      color: colors.textDark,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.createProjectSubtitle,
                    style: TextStyle(color: colors.textLight, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  ProjectNameField(
                    controller: _nameController,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.chooseIcon,
                    style: TextStyle(
                      color: colors.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProjectIconPicker(
                    icons: availableProjectIcons,
                    selectedIndex: _selectedIconIndex,
                    enabled: !isLoading,
                    onSelected: (index) =>
                        setState(() => _selectedIconIndex = index),
                  ),
                  const SizedBox(height: 32),
                  CreateProjectButton(
                    isLoading: isLoading,
                    label: l10n.createProjectButton,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ProjectCubit>().createProject(
                          name: _nameController.text.trim(),
                          iconCodePoint:_selectedIconIndex,
                             
                        );
                      }
                    },
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
