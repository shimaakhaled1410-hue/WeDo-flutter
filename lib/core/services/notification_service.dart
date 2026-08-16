import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wedo_flutter/core/router/app_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/services/service_locator.dart' as di;
import 'package:wedo_flutter/core/widgets/in_app_notification_banner.dart';
import 'package:wedo_flutter/domain/usecases/project/get_project_by_id_usecase.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AudioPlayer _player = AudioPlayer();

  Future<void> initNotification() async {
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

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {}
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    final navState = AppRouter.navigatorKey.currentState;
    final overlayState = navState?.overlay;

    if (notification != null && overlayState != null) {
      _playNotificationSound();

      InAppNotificationBanner.show(
        overlayState,
        title: notification.title ?? '',
        body: notification.body ?? '',
        onTap: () => _navigateFromNotification(data),
      );
    }
  }

  Future<void> _playNotificationSound() async {
    try {
      await _player.play(AssetSource('sounds/notification-sound.wav'));
    } catch (_) {}
  }

  Future<void> _navigateFromNotification(Map<String, dynamic> data) async {
    final projectId = data['projectId'] as String?;
    if (projectId == null || projectId.isEmpty) return;

    final result = await di.sl<GetProjectByIdUseCase>().call(projectId);

    result.fold(
      (failure) {},
      (project) =>
          AppRouter.router.push(AppRoutes.projectDetails, extra: project),
    );
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
