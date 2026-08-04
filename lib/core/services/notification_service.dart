import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background Message: ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
    });
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('permission request ${settings.authorizationStatus}');
  }

  Future<String?> getToken() async {
    final token = await _fcm.getToken();
    debugPrint('token: $token');
    return token;
  }
}
