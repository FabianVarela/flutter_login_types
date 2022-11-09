import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/providers/app_provider.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/core/services/notification_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required AppProvider appProvider,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  final overrides = <Override>[
    sharedPreferencesProvider.overrideWithValue(
      await SharedPreferences.getInstance(),
    ),
    localAuthenticationProvider.overrideWith(
      (ref) => ref.watch(appProvider.localAuthentication),
    ),
    preferencesProvider.overrideWith(
      (ref) => ref.watch(appProvider.preferences),
    ),
    localNotificationsProvider.overrideWith(
      (ref) => ref.watch(appProvider.localNotifications),
    ),
    loginClientProvider.overrideWith(
      (ref) => ref.watch(appProvider.loginClient),
    ),
    languageRepositoryProvider.overrideWith(
      (ref) => ref.watch(appProvider.languageRepository),
    ),
    loginRepositoryProvider.overrideWith(
      (ref) => ref.watch(appProvider.loginRepository),
    ),
    notificationServiceProvider.overrideWith(
      (ref) => ref.watch(appProvider.notificationService),
    ),
  ];

  await runZonedGuarded(
    () async => runApp(
      ProviderScope(overrides: overrides, child: await builder()),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

AppProvider configureAppProvider() {
  return AppProvider(
    localAuthentication: Provider((_) => LocalAuthentication()),
    preferences: Provider(
      (ref) => Preferences(ref.watch(sharedPreferencesProvider)),
    ),
    localNotifications: Provider((_) => FlutterLocalNotificationsPlugin()),
    loginClient: Provider((_) => LoginClient()),
    languageRepository: Provider(
      (ref) => LanguageRepository(ref.read(preferencesProvider)),
    ),
    loginRepository: Provider(
      (ref) => LoginRepository(ref.watch(loginClientProvider)),
    ),
    notificationService: Provider(
      (ref) => NotificationService(ref.watch(localNotificationsProvider)),
    ),
  );
}
