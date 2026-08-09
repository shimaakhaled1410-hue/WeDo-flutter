import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/theme/app_colors.dart';
import 'package:wedo_flutter/domain/entities/project_entity.dart';
import 'package:wedo_flutter/presentation/manager/tasks/task_cubit.dart';

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

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
             if (!isOnlyMember) ...[
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'Assign to:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.project.collaboratorsIds.length,
                  itemBuilder: (context, index) {
                    final collabId = widget.project.collaboratorsIds[index];
                    
                    final collabImage = (widget.project.collaboratorsImages.isNotEmpty &&
                            widget.project.collaboratorsImages.length > index)
                        ? widget.project.collaboratorsImages[index]
                        : '';
                        
                    final namesList = widget.project.collaboratorsNames;
                    final collabName = (namesList != null && namesList.isNotEmpty && namesList.length > index)
                        ? namesList[index]
                        : 'Member';

                    final isSelected = selectedUserId == collabId;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedUserId = null;
                            selectedUserImage = null;
                            selectedUserName = null;
                          } else {
                            selectedUserId = collabId;
                            selectedUserImage = collabImage;
                            selectedUserName = collabName;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent.withValues(alpha:0.1) : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.white,
                              backgroundImage: collabImage.isNotEmpty ? NetworkImage(collabImage) : null,
                              child: collabImage.isEmpty
                                  ? const Icon(Icons.person, size: 18, color: AppColors.textLight)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                collabName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : Colors.black87,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.accent,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
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
                  onPressed: (!isOnlyMember && selectedUserId == null)
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<TaskCubit>().createTask(
                              projectId: widget.project.id,
                              title: _taskController.text.trim(),
                              creatorId: currentUserId,
                              assignedToUserId: isOnlyMember
                                  ? currentUserId
                                  : selectedUserId,
                              assignedToUserImage: isOnlyMember
                                  ? currentUserImage
                                  : selectedUserImage,
                              assignedToUserName: isOnlyMember
                                  ? currentUserName
                                  : selectedUserName,
                            );
                            context.pop();
                          }
                        },
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (!isOnlyMember && selectedUserId == null)
                          ? Colors.grey.shade500
                          : Colors.white,
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
