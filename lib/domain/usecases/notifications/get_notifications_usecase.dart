
import 'package:wedo_flutter/domain/entities/notification_entity.dart';
import 'package:wedo_flutter/domain/repo/notification_repo.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Stream<List<NotificationEntity>> call() {
    return repository.getNotifications();
  }
}