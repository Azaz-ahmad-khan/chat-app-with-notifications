import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noti_chat/ui/views/chat/chat_view.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background Message: ${message.notification?.title}');
}

class NotificationService {
  static final GlobalKey<NavigatorState> navigationKey =
      GlobalKey<NavigatorState>();
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('message tapped from background');
      handleNotificationNavigation(message.data);
    });

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('app opened from terminated state via notification');
      await Future.delayed((Duration(seconds: 1)));
      handleNotificationNavigation(initialMessage.data);
    }
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

  void handleNotificationNavigation(Map<String, dynamic> data) {
    debugPrint('Notification Data: $data');
    final screen = data['screen'];
    final senderId = data['senderId'];
    final name = data['senderName'];

    if (screen == 'chat' && senderId != null) {
      navigationKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ChatView(
            user: {
              'userId': senderId,
              'email': name ?? 'unknown',
              'name': name ?? 'unknown',
            },
          ),
        ),
      );
    }
  }
}
