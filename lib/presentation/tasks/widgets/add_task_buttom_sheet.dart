import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/extensions/localization_x.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
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
    currentUserImage = (currentUserIndex != -1 && currentUserIndex < widget.project.collaboratorsImages.length)
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
    final colors = context.colors;
    final l10n = context.l10n;
    final isDisabled = !isOnlyMember && selectedUserId == null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        decoration: BoxDecoration(color: colors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
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
                  decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Text(l10n.addNewTask, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textDark)),
              const SizedBox(height: 18),
              TextFormField(
                controller: _taskController,
                autofocus: true,
                style: TextStyle(color: colors.textDark, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: l10n.whatNeedsToBeDone,
                  hintStyle: TextStyle(color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surfaceMuted,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.primary, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? l10n.taskTitleRequired : null,
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
                    gradient: isDisabled ? null : colors.primaryGradient,
                    color: isDisabled ? colors.surfaceMuted : null,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isDisabled ? null : colors.softShadow,
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
                      l10n.addTask,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5, color: isDisabled ? colors.textMuted : Colors.white),
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