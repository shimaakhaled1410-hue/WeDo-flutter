import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.titleEn,
    required super.titleAr,
    required super.bodyEn,
    required super.bodyAr,
    super.taskId,
    super.projectName,
    super.projectId,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> json, String id) {
    // Backward compatibility: old docs only have flat 'title'/'body' strings.
    final legacyTitle = json['title'] as String?;
    final legacyBody = json['body'] as String?;

    return NotificationModel(
      id: id,
      titleEn: json['titleEn'] ?? legacyTitle ?? '',
      titleAr: json['titleAr'] ?? legacyTitle ?? '',
      bodyEn: json['bodyEn'] ?? legacyBody ?? '',
      bodyAr: json['bodyAr'] ?? legacyBody ?? '',
      taskId: json['taskId'],
      projectName: json['projectName'],
      projectId: json['projectId'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}