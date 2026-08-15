import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wedo_flutter/core/router/app_router.dart';
import 'package:wedo_flutter/core/widgets/in_app_notification_banner.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initNotification() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _fcm.getToken();

      if (token != null) {
        await saveTokenToFirestore(token);
      }

      _fcm.onTokenRefresh.listen(saveTokenToFirestore);

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final ctx = AppRouter.navigatorKey.currentContext;

    if (notification != null && ctx != null) {
      InAppNotificationBanner.show(
        ctx,
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    }
  }

  Future<void> saveTokenToFirestore(String token) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }
}