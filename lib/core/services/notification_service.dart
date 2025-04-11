import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({required this.localNotifications});

  final FlutterLocalNotificationsPlugin localNotifications;

  void init() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(badge: true, sound: true);
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('flutter_login_types'),
      iOS: DarwinInitializationSettings(),
    );

    localNotifications.initialize(initSettings);
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    await localNotifications.show(0, title, body, platformChannelSpecifics);
  }
}
