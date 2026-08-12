import 'package:equatable/equatable.dart';
import '../../../domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasUnread;

  const NotificationLoaded({
    required this.notifications,
    required this.hasUnread,
  });

  @override
  List<Object?> get props => [notifications, hasUnread];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}