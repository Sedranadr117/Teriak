
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:teriak/config/routes/app_pages.dart' show AppPages;
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("🔥 Background Message Received: ${message.messageId}");
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const String fcmTokenKey = "fcm_token";

  // Callback for notification received
  Function(RemoteMessage)? onNotificationReceived;
  Function(RemoteMessage)? onNotificationClicked;

  Future<void> init() async {
    await _initLocalNotifications();
    await _requestPermission();

    // save token & refresh listening
    await getAndSaveToken();
    _listenTokenRefresh();

    // foreground notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // app opened from notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    // background & terminated messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // app opened from terminated via notification
    _checkIfAppOpenedFromTerminated();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

 Future<void> _initLocalNotifications() async {
  // 1) إعدادات البداية
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);

  // 2) إنشاء Notification Channel (مهم جداً)
  final androidImplementation =
      _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation?.createNotificationChannel(
    const AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
    ),
  );

  // 3) تهيئة local notifications
  await _local.initialize(settings);
}


  Future<void> getAndSaveToken() async {
    final token = await _messaging.getToken();
    print("🔑 FCM Token: $token");

    if (token != null) {
      await CacheHelper().saveData(key: fcmTokenKey, value: token);
    }
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      print("♻️ Token Refreshed: $newToken");
      await CacheHelper().saveData(key: fcmTokenKey, value: newToken);
    });
  }

  String? getSavedToken() {
    return CacheHelper().getDataString(key: fcmTokenKey);
  }

  // when user taps notification and the app was terminated
  Future<void> _checkIfAppOpenedFromTerminated() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("📩 App opened from terminated via notification");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      // Notify controller if callback is set
      onNotificationClicked?.call(message);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _showLocalNotification(
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
    );
    // Notify controller if callback is set
    onNotificationReceived?.call(message);
  }

  void _handleNotificationClick(RemoteMessage message) {
    print("➡️ User clicked notification (background)");
    // Notify controller if callback is set
    onNotificationClicked?.call(message);
      // Navigation
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const platform = NotificationDetails(android: androidDetails);
    await _local.show(
      DateTime.now().millisecond,
      title,
      body,
      platform,
    );
  }
}
