import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'alert_time_picker_section.dart';
import 'assign_collaborator_section.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key, required this.project});

  final ProjectEntity project;

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();

  late String currentUserId;
  late String currentUserName;
  late String currentUserImage;
  late bool isOnlyMember;

  String? selectedUserId;
  String? selectedUserImage;
  String? selectedUserName;
  DateTime? selectedAlertTime;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _initializeUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    currentUserId = currentUser?.uid ?? '';
    currentUserName = currentUser?.displayName ?? 'Me';

    final currentUserIndex = widget.project.collaboratorsIds.indexOf(currentUserId);
    currentUserImage = (currentUserIndex != -1 &&
            currentUserIndex < widget.project.collaboratorsImages.length)
        ? widget.project.collaboratorsImages[currentUserIndex]
        : currentUser?.photoURL ?? '';

    isOnlyMember = widget.project.collaboratorsIds.length <= 1;
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      context.read<TaskCubit>().createTask(
            projectId: widget.project.id,
            title: _taskController.text.trim(),
            creatorId: currentUserId,
            assignedToUserId: isOnlyMember ? currentUserId : selectedUserId,
            assignedToUserImage: isOnlyMember ? currentUserImage : selectedUserImage,
            assignedToUserName: isOnlyMember ? currentUserName : selectedUserName,
            alertTime: selectedAlertTime,
          );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = !isOnlyMember && selectedUserId == null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Add New Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _taskController,
                autofocus: true,
                style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter task title' : null,
              ),
              if (!isOnlyMember)
                AssignCollaboratorSection(
                  project: widget.project,
                  selectedUserId: selectedUserId,
                  onAssign: (id, image, name) {
                    setState(() {
                      selectedUserId = id;
                      selectedUserImage = image;
                      selectedUserName = name;
                    });
                  },
                ),
              const SizedBox(height: 20),
              AlertTimePickerSection(
                selectedAlertTime: selectedAlertTime,
                onTimeSelected: (time) => setState(() => selectedAlertTime = time),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: isDisabled ? null : AppColors.primaryGradient,
                    color: isDisabled ? AppColors.surfaceMuted : null,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isDisabled ? null : AppColors.softShadow,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isDisabled ? null : _submitTask,
                    child: Text(
                      'Add Task',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                        color: isDisabled ? AppColors.textMuted : AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}