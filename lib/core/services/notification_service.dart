import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._localNotifications);

  final FlutterLocalNotificationsPlugin _localNotifications;

  void init() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(badge: true, sound: true);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('flutter_login_types'),
      iOS: DarwinInitializationSettings(),
    );

    _localNotifications.initialize(initSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const androidChannel = AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidChannel,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    await _localNotifications.show(0, title, body, platformChannelSpecifics);
  }
}
