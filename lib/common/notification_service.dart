import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService();

  static NotificationService getInstance() => _instance;

  late FlutterLocalNotificationsPlugin _localNotifications;

  void init() {
    _localNotifications = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    const initSettingsAndroid = AndroidInitializationSettings('login_bloc');
    const initSettingsIOS = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    _localNotifications.initialize(initSettings);
  }

  void _requestIOSPermission() {
    _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(badge: true, sound: true);
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

    const iosChannel = DarwinNotificationDetails(presentSound: true);

    const platformChannelSpecifics = NotificationDetails(
      android: androidChannel,
      iOS: iosChannel,
    );

    await _localNotifications.show(0, title, body, platformChannelSpecifics);
  }
}
