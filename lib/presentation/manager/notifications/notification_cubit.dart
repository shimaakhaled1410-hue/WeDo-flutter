import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/domain/usecases/notifications/get_notifications_usecase.dart';
import 'package:wedo_flutter/domain/usecases/notifications/mark_notification_as_read_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  StreamSubscription? _subscription;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(NotificationInitial());

  void getNotifications() {
    emit(NotificationLoading());
    _subscription?.cancel();
    _subscription = getNotificationsUseCase().listen(
      (notifications) {
        final hasUnread = notifications.any((n) => !n.isRead);
        emit(NotificationLoaded(
          notifications: notifications,
          hasUnread: hasUnread,
        ));
      },
      onError: (error) => emit(NotificationError(error.toString())),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await markNotificationAsReadUseCase(notificationId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}