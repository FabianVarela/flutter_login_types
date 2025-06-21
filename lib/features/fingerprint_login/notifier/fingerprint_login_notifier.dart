import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:uuid/uuid.dart';

final hasBiometricProvider = FutureProvider.autoDispose((ref) async {
  final localAuth = ref.watch(localAuthenticationProvider);

  final canAuthBiometrics = await localAuth.canCheckBiometrics;
  final isDeviceSupported = await localAuth.isDeviceSupported();

  return canAuthBiometrics || isDeviceSupported;
});

final listBiometricProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(localAuthenticationProvider).getAvailableBiometrics(),
);

enum LocalAuthOption { none, granted, denied }

typedef LocalAuthInfo = ({LocalAuthOption option, String? token});

class LocalAuthNotifier extends AutoDisposeAsyncNotifier<LocalAuthInfo> {
  @override
  FutureOr<LocalAuthInfo> build() {
    return (option: LocalAuthOption.none, token: null);
  }

  Future<void> authenticate({required String reason}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final authProvider = ref.read(localAuthenticationProvider);
        final isAuthorized = await authProvider.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(stickyAuth: true),
        );

        final option = switch (isAuthorized) {
          true => LocalAuthOption.granted,
          _ => LocalAuthOption.denied,
        };
        return (option: option, token: const Uuid().v4());
      } on PlatformException catch (_) {
        return (option: LocalAuthOption.denied, token: null);
      }
    });
  }
}

final localAuthNotifierProvider = AsyncNotifierProvider.autoDispose(
  LocalAuthNotifier.new,
);
