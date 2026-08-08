import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';

class ProjectCollaboratorsBar extends StatelessWidget {
  final String projectId;
  final List<String> collaboratorsImages;

  const ProjectCollaboratorsBar({
    super.key,
    required this.projectId,
    required this.collaboratorsImages,
  });

  void _shareInviteLink(BuildContext context) {
    final inviteUrl = 'wedo://join?projectId=$projectId';
    Clipboard.setData(ClipboardData(text: inviteUrl));

    CustomSnackBar.show(
      context: context,
      message: 'Invite link copied to clipboard! Share it with your team.',
    );
  }

  @override
  Widget build(BuildContext context) {
    const maxDisplayed = 3;
    final hasMore = collaboratorsImages.length > maxDisplayed;
    final displayCount = hasMore
        ? maxDisplayed + 1
        : collaboratorsImages.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 36,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(displayCount, (index) {
              if (hasMore && index == maxDisplayed) {
                final remaining = collaboratorsImages.length - maxDisplayed;
                return Align(
                  widthFactor: 0.65,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      '+$remaining',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              return Align(
                widthFactor: 0.65,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: collaboratorsImages[index].isNotEmpty
                      ? NetworkImage(collaboratorsImages[index])
                      : null,
                  child: collaboratorsImages[index].isEmpty
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),
              );
            }),
          ),
        ),

        IconButton.filledTonal(
          onPressed: () => _shareInviteLink(context),
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
          tooltip: 'Invite Collaborator',
        ),
      ],
    );
  }
}
