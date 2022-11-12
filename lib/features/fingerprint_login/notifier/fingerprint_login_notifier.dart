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

enum LocalAuthOption { none, loading, granted, denied }

class LocalAuthNotifier extends StateNotifier<LocalAuthOption> {
  LocalAuthNotifier(this._localAuth, [super.state = LocalAuthOption.none]);

  final LocalAuthentication _localAuth;

  Future<void> authenticate(String reason) async {
    try {
      state = LocalAuthOption.loading;

      final isAuthorized = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(stickyAuth: true),
      );

      state = isAuthorized ? LocalAuthOption.granted : LocalAuthOption.denied;
    } on PlatformException catch (_) {
      state = LocalAuthOption.denied;
    }
  }
}
