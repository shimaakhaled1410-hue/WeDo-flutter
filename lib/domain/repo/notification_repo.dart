import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Stream<List<NotificationEntity>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String notificationId);
}
