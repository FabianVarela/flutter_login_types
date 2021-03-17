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

    var initSettingsAndroid = AndroidInitializationSettings('login_bloc');
    var initSettingsIOS = IOSInitializationSettings();

    var initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    _localNotifications.initialize(initSettings);
  }

  void _requestIOSPermission() {
    _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  Future<void> showNotification(String title, String body) async {
    var androidChannel = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );

    var iosChannel = IOSNotificationDetails(presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
      android: androidChannel,
      iOS: iosChannel,
    );

    await _localNotifications.show(0, title, body, platformChannelSpecifics);
  }
}
