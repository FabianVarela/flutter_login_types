import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TotpPhase { setup, verify }

typedef TotpInfo = ({TotpPhase phase, String secret, String? token});

class TotpLoginNotifier extends AsyncNotifier<TotpInfo> {
  @override
  FutureOr<TotpInfo> build() {
    final secret = ref.read(totpCoreServiceProvider).generateSecret();
    return (phase: TotpPhase.setup, secret: secret, token: null);
  }

  void restore() {
    final secret = ref.read(totpCoreServiceProvider).generateSecret();
    state = AsyncValue.data(
      (phase: TotpPhase.setup, secret: secret, token: null),
    );
  }

  Future<void> confirmSetup({required String code}) async {
    final currentSecret = state.value?.secret ?? '';

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final totpCore = ref.read(totpCoreServiceProvider);
      final valid = totpCore.verifyCode(secret: currentSecret, code: code);

      if (valid) {
        return (phase: TotpPhase.verify, secret: currentSecret, token: null);
      }
      throw Exception();
    });
  }

  Future<void> authenticate({required String code}) async {
    final currentSecret = state.value?.secret ?? '';

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final totpCore = ref.read(totpCoreServiceProvider);
      final repository = ref.read(totpLoginRepositoryProvider);

      final verified = totpCore.verifyCode(secret: currentSecret, code: code);
      final token = await repository.authenticate(hasVerifiedCode: verified);

      if (token != null) {
        return (phase: TotpPhase.verify, secret: currentSecret, token: token);
      }
      throw Exception();
    });
  }
}

final totpLoginNotifierProvider = AsyncNotifierProvider.autoDispose(
  TotpLoginNotifier.new,
);
