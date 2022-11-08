import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_types/client/login_client.dart';
import 'package:flutter_login_types/client/preferences.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/providers/app_provider.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:flutter_login_types/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    preferencesProvider.overrideWith(
      (ref) => ref.watch(appProvider.preferences),
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
    preferences: Provider<Preferences>(
      (ref) => Preferences(ref.watch(sharedPreferencesProvider)),
    ),
    loginClient: Provider<LoginClient>((_) => LoginClient()),
    languageRepository: Provider(
      (ref) => LanguageRepository(ref.read(preferencesProvider)),
    ),
    loginRepository: Provider<LoginRepository>(
      (ref) => LoginRepository(ref.watch(loginClientProvider)),
    ),
  );
}
