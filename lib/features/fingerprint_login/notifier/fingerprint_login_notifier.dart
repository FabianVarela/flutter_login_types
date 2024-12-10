import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final hasBiometricProvider = FutureProvider.autoDispose<bool>((ref) async {
  final localAuth = ref.watch(localAuthenticationProvider);

  final canAuthBiometrics = await localAuth.canCheckBiometrics;
  final isDeviceSupported = await localAuth.isDeviceSupported();

  return canAuthBiometrics || isDeviceSupported;
});

final listBiometricProvider = FutureProvider.autoDispose<List<BiometricType>>(
  (ref) => ref.watch(localAuthenticationProvider).getAvailableBiometrics(),
);

enum LocalAuthOption { none, granted, denied }

class LocalAuthNotifier extends AutoDisposeAsyncNotifier<LocalAuthOption> {
  @override
  FutureOr<LocalAuthOption> build() => LocalAuthOption.none;

  Future<void> authenticate({required String reason}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final authProvider = ref.read(localAuthenticationProvider);
        final isAuthorized = await authProvider.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(stickyAuth: true),
        );

        return isAuthorized ? LocalAuthOption.granted : LocalAuthOption.denied;
      } on PlatformException catch (_) {
        return LocalAuthOption.denied;
      }
    });
  }
}

final localAuthNotifierProvider =
    AsyncNotifierProvider.autoDispose<LocalAuthNotifier, LocalAuthOption>(
  LocalAuthNotifier.new,
);
