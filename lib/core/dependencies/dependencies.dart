import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must implement SharedPreferences provider');
});

final localAuthenticationProvider = Provider<LocalAuthentication>(
  (_) => LocalAuthentication(),
);

final preferencesProvider = Provider<Preferences>(
  (ref) => Preferences(ref.watch(sharedPreferencesProvider)),
);

final localNotificationsProvider = Provider<FlutterLocalNotificationsPlugin>(
  (_) => FlutterLocalNotificationsPlugin(),
);

final appAuthProvider = Provider<FlutterAppAuth>(
  (_) => const FlutterAppAuth(),
);

final loginClientProvider = Provider<LoginClient>(
  (ref) => LoginClient(ref.watch(appAuthProvider)),
);

final languageRepositoryProvider = Provider<LanguageRepository>(
  (ref) => LanguageRepository(ref.watch(preferencesProvider)),
);

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => LoginRepository(ref.watch(loginClientProvider)),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(ref.watch(localNotificationsProvider)),
);
