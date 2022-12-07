import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must implement SharedPreferences provider');
});

final localAuthenticationProvider = Provider<LocalAuthentication>((ref) {
  throw UnimplementedError('You must implement LocalAuthentication provider');
});

final preferencesProvider = Provider<Preferences>((_) {
  throw UnimplementedError('You must implement Preferences provider');
});

final localNotificationsProvider = Provider<FlutterLocalNotificationsPlugin>(
  (_) => throw UnimplementedError(
    'You must implement FlutterLocalNotificationsPlugin provider',
  ),
);

final appAuthProvider = Provider<FlutterAppAuth>(
  (_) => throw UnimplementedError('You must implement FlutterAppAuth provider'),
);

final loginClientProvider = Provider<LoginClient>((_) {
  throw UnimplementedError('You must implement LoginClient provider');
});

final languageRepositoryProvider = Provider<LanguageRepository>((_) {
  throw UnimplementedError('You must implement LanguageRepository provider');
});

final loginRepositoryProvider = Provider<LoginRepository>((_) {
  throw UnimplementedError('You must implement LoginRepository provider');
});

final notificationServiceProvider = Provider<NotificationService>((_) {
  throw UnimplementedError('You must implement NotificationService provider');
});

final languageNotifierProvider =
    StateNotifierProvider.autoDispose<LanguageNotifier, Locale?>(
  (ref) => LanguageNotifier(ref.read(languageRepositoryProvider)),
);
