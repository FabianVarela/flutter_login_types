import 'package:auth0_flutter/auth0_flutter.dart' show Auth0;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/logout_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/client/secure_storage.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/logout_repository.dart';
import 'package:flutter_login_types/core/repository/session_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:flutter_login_types/features/mechanism_login/client/mechanism_login_client.dart';
import 'package:flutter_login_types/features/mechanism_login/repository/mechanism_login_repository.dart';
import 'package:flutter_login_types/features/passcode_login/client/passcode_login_client.dart';
import 'package:flutter_login_types/features/passcode_login/repository/passcode_login_repository.dart';
import 'package:flutter_login_types/features/simple_login/client/simple_login_client.dart';
import 'package:flutter_login_types/features/simple_login/repository/simple_login_repository.dart';
import 'package:flutter_login_types/features/third_login/client/third_party_login_client.dart';
import 'package:flutter_login_types/features/third_login/repository/third_party_login_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final flutterSecureStorageProvider = Provider((_) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must implement SharedPreferences provider');
});

final localAuthenticationProvider = Provider((_) => LocalAuthentication());

final secureStorageProvider = Provider(
  (ref) => SecureStorage(
    flutterSecureStorage: ref.watch(flutterSecureStorageProvider),
  ),
);

final preferencesProvider = Provider(
  (ref) => Preferences(sharedPreferences: ref.watch(sharedPreferencesProvider)),
);

final localNotificationsProvider = Provider(
  (_) => FlutterLocalNotificationsPlugin(),
);

final appAuthProvider = Provider((_) => const FlutterAppAuth());

final auth0Provider = Provider((ref) {
  final auth0Config = ref.watch(appConfigProvider).auth0Config;
  return Auth0(auth0Config.domain, auth0Config.clientId);
});

final appConfigProvider = Provider((_) => AppConfig());

final simpleLoginClientProvider = Provider((_) => SimpleLoginClient());

final passcodeLoginClientProvider = Provider((_) => PasscodeLoginClient());

final thirdPartyLoginClientProvider = Provider(
  (ref) => ThirdPartyLoginClient(appConfig: ref.watch(appConfigProvider)),
);

final mechanismLoginClientProvider = Provider(
  (ref) => MechanismLoginClient(
    appConfig: ref.watch(appConfigProvider),
    appAuth: ref.watch(appAuthProvider),
    auth0: ref.watch(auth0Provider),
  ),
);

final sessionRepositoryProvider = Provider((ref) {
  return SessionRepository(secureStorage: ref.watch(secureStorageProvider));
});

final languageRepositoryProvider = Provider(
  (ref) => LanguageRepository(preferences: ref.watch(preferencesProvider)),
);

final simpleLoginRepositoryProvider = Provider(
  (ref) => SimpleLoginRepository(client: ref.watch(simpleLoginClientProvider)),
);

final passcodeLoginRepositoryProvider = Provider(
  (ref) => PasscodeLoginRepository(
    client: ref.watch(passcodeLoginClientProvider),
  ),
);

final thirdPartyLoginRepositoryProvider = Provider(
  (ref) => ThirdPartyLoginRepository(
    client: ref.watch(thirdPartyLoginClientProvider),
  ),
);

final mechanismLoginRepositoryProvider = Provider(
  (ref) => MechanismLoginRepository(
    client: ref.watch(mechanismLoginClientProvider),
  ),
);

final logoutClientProvider = Provider(
  (ref) => LogoutClient(
    appConfig: ref.watch(appConfigProvider),
    auth0: ref.watch(auth0Provider),
  ),
);

final logoutRepositoryProvider = Provider(
  (ref) => LogoutRepository(client: ref.watch(logoutClientProvider)),
);

final notificationServiceProvider = Provider(
  (ref) => NotificationService(
    localNotifications: ref.watch(localNotificationsProvider),
  ),
);
