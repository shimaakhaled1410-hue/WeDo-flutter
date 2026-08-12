import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Stream<List<NotificationModel>> getNotifications() {
    final userId = auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}