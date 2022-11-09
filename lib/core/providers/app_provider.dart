import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class AppProvider {
  AppProvider({
    required this.localAuthentication,
    required this.preferences,
    required this.localNotifications,
    required this.loginClient,
    required this.languageRepository,
    required this.loginRepository,
    required this.notificationService,
  });

  final Provider<LocalAuthentication> localAuthentication;
  final Provider<Preferences> preferences;
  final Provider<FlutterLocalNotificationsPlugin> localNotifications;
  final Provider<LoginClient> loginClient;
  final Provider<LanguageRepository> languageRepository;
  final Provider<LoginRepository> loginRepository;
  final Provider<NotificationService> notificationService;
}
