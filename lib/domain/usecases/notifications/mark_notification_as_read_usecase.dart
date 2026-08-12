
import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/domain/repo/notification_repo.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}