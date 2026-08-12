import 'package:dartz/dartz.dart';
import 'package:wedo_flutter/core/error/failure.dart';
import 'package:wedo_flutter/data/datasource/notification_remote_datasource.dart';
import 'package:wedo_flutter/domain/entities/notification_entity.dart';
import 'package:wedo_flutter/domain/repo/notification_repo.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<NotificationEntity>> getNotifications() {
    return remoteDataSource.getNotifications();
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}