import 'package:auth0_flutter/auth0_flutter.dart' show Auth0;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/client/secure_storage.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/core/repository/session_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((_) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must implement SharedPreferences provider');
});

final localAuthenticationProvider = Provider<LocalAuthentication>(
  (_) => LocalAuthentication(),
);

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(
    flutterSecureStorage: ref.watch(flutterSecureStorageProvider),
  ),
);

final preferencesProvider = Provider<Preferences>(
  (ref) => Preferences(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  ),
);

final localNotificationsProvider = Provider<FlutterLocalNotificationsPlugin>(
  (_) => FlutterLocalNotificationsPlugin(),
);

final appAuthProvider = Provider<FlutterAppAuth>(
  (_) => const FlutterAppAuth(),
);

final auth0Provider = Provider<Auth0>((ref) {
  final auth0Config = ref.watch(appConfigProvider).auth0Config;
  return Auth0(auth0Config.domain, auth0Config.clientId);
});

final appConfigProvider = Provider<AppConfig>((_) => AppConfig());

final loginClientProvider = Provider<LoginClient>(
  (ref) => LoginClient(
    appConfig: ref.watch(appConfigProvider),
    appAuth: ref.watch(appAuthProvider),
    auth0: ref.watch(auth0Provider),
  ),
);

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(secureStorage: ref.watch(secureStorageProvider));
});

final languageRepositoryProvider = Provider<LanguageRepository>(
  (ref) => LanguageRepository(preferences: ref.watch(preferencesProvider)),
);

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => LoginRepository(client: ref.watch(loginClientProvider)),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    localNotifications: ref.watch(localNotificationsProvider),
  ),
);
