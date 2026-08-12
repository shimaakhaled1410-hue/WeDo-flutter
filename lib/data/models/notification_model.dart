import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.taskId,
    super.projectName,
    super.projectId,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      taskId: json['taskId'],
      projectName: json['projectName'],
      projectId: json['projectId'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}
