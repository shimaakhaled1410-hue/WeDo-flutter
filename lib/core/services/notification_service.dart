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
    // Registered unconditionally: this powers our custom in-app banner,
    // not the system tray, so it must not depend on the OS permission
    // result below.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _fcm.getToken();
    if (token != null) {
      await saveTokenToFirestore(token);
    }

    _fcm.onTokenRefresh.listen(saveTokenToFirestore);

    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        final currentToken = await _fcm.getToken();
        if (currentToken != null) {
          await saveTokenToFirestore(currentToken);
        }
      }
    });

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // ignore: avoid_print
      print('⚠️ Notification permission not granted: ${settings.authorizationStatus}');
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