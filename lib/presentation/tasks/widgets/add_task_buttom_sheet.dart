import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';
import 'assign_collaborator_section.dart';
import 'alert_time_picker_section.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final ProjectEntity project;

  const AddTaskBottomSheet({super.key, required this.project});

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

    final currentUserIndex = widget.project.collaboratorsIds.indexOf(
      currentUserId,
    );
    currentUserImage =
        (currentUserIndex != -1 &&
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
        assignedToUserImage: isOnlyMember
            ? currentUserImage
            : selectedUserImage,
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
              const Center(
                child: Text(
                  'Add New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _taskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter task title'
                    : null,
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
                onTimeSelected: (time) {
                  setState(() {
                    selectedAlertTime = time;
                  });
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isDisabled ? null : _submitTask,
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDisabled ? Colors.grey.shade500 : Colors.white,
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
