import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.messageId}');
}

/// Notification service for push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Request permission
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up message handlers
    _setupMessageHandlers();

    // Set background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _isInitialized = true;

    // Get and print the FCM token
    final token = await getToken();
    debugPrint('FCM Token: $token');
  }

  /// Request notification permission
  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'la_gym_channel',
        'LA GYM Notifications',
        description: 'Notifications from LA GYM app',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      debugPrint('Notification tapped with payload: $payload');
      // Handle navigation based on payload
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _handleNotificationNavigation(data);
    }
  }

  /// Set up FCM message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground message received: ${message.messageId}');
      _showLocalNotification(message);
    });

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('App opened from notification: ${message.messageId}');
      if (message.data.isNotEmpty) {
        _handleNotificationNavigation(message.data);
      }
    });
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'la_gym_channel',
      'LA GYM Notifications',
      channelDescription: 'Notifications from LA GYM app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle navigation from notification
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    // Navigate based on notification type
    switch (type) {
      case 'workout':
        // Navigate to workout detail
        debugPrint('Navigate to workout: $id');
        break;
      case 'challenge':
        // Navigate to challenges
        debugPrint('Navigate to challenges');
        break;
      case 'recipe':
        // Navigate to recipe
        debugPrint('Navigate to recipe: $id');
        break;
      case 'motivation':
        // Navigate to home
        debugPrint('Navigate to home (motivation)');
        break;
      default:
        debugPrint('Unknown notification type: $type');
    }
  }

  /// Get FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  /// Show a local notification (for testing or in-app notifications)
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'la_gym_channel',
      'LA GYM Notifications',
      channelDescription: 'Notifications from LA GYM app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Schedule a notification
  Future<void> scheduleMotivationalNotification({
    required int hour,
    required int minute,
  }) async {
    // This would schedule daily motivational messages
    // Implementation requires timezone handling
    debugPrint('Scheduled motivational notification for $hour:$minute');
  }
}

/// Notification service provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Daily motivational messages
final motivationalMessages = [
  "Your only limit is you. Let's crush today's workout!",
  "Every rep counts. Every step matters. Keep moving forward!",
  "The hardest part is showing up. You've already done that!",
  "Strong is the new beautiful. You're building strength today!",
  "Progress, not perfection. Keep going!",
  "Your future self will thank you for this workout.",
  "One workout closer to your goals. Let's go!",
  "Sweat now, shine later. You've got this!",
  "Make yourself proud today. Time to workout!",
  "Champions are made when no one is watching. Let's train!",
];

/// Get a random motivational message
String getRandomMotivationalMessage() {
  return motivationalMessages[DateTime.now().millisecondsSinceEpoch % motivationalMessages.length];
}
