import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum OauthTotpPhase { idle, setup, verify }

typedef OauthTotpInfo = ({
  OauthTotpPhase phase,
  String oauthUserId,
  String totpSecret,
  String? token,
});

class OauthTotpLoginNotifier extends AsyncNotifier<OauthTotpInfo> {
  static const _totpPrefix = 'oauth_totp_';

  @override
  FutureOr<OauthTotpInfo> build() => (
    phase: OauthTotpPhase.idle,
    oauthUserId: '',
    totpSecret: '',
    token: null,
  );

  void restore() {
    state = const AsyncValue.data((
      phase: OauthTotpPhase.idle,
      oauthUserId: '',
      totpSecret: '',
      token: null,
    ));
  }

  Future<void> signInWithOAuth() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final totpCore = ref.read(totpCoreServiceProvider);
      final repository = ref.read(oauthTotpLoginRepositoryProvider);

      final userId = await repository.signInWithOAuth();
      if (userId == null) {
        return (
          phase: OauthTotpPhase.idle,
          oauthUserId: '',
          totpSecret: '',
          token: null,
        );
      }

      final existingSecret = await totpCore.getTotpSecret(userId, _totpPrefix);
      if (existingSecret != null) {
        return (
          phase: OauthTotpPhase.verify,
          oauthUserId: userId,
          totpSecret: existingSecret,
          token: null,
        );
      }

      return (
        phase: OauthTotpPhase.setup,
        oauthUserId: userId,
        totpSecret: totpCore.generateSecret(),
        token: null,
      );
    });
  }

  Future<void> confirmSetup({required String code}) async {
    final current = state.value;
    if (current == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final totpCore = ref.read(totpCoreServiceProvider);
      final valid = totpCore.verifyCode(secret: current.totpSecret, code: code);

      if (valid) {
        await totpCore.saveTotpSecret(
          current.oauthUserId,
          current.totpSecret,
          _totpPrefix,
        );

        return (
          phase: OauthTotpPhase.verify,
          oauthUserId: current.oauthUserId,
          totpSecret: current.totpSecret,
          token: null,
        );
      }
      throw Exception();
    });
  }

  Future<void> authenticate({required String code}) async {
    final current = state.value;
    if (current == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final totpCore = ref.read(totpCoreServiceProvider);
      final repository = ref.read(oauthTotpLoginRepositoryProvider);

      final valid = totpCore.verifyCode(secret: current.totpSecret, code: code);
      if (valid) {
        final token = await repository.generateToken();
        return (
          phase: OauthTotpPhase.verify,
          oauthUserId: current.oauthUserId,
          totpSecret: current.totpSecret,
          token: token,
        );
      }
      throw Exception();
    });
  }
}

final oauthTotpLoginNotifierProvider = AsyncNotifierProvider.autoDispose(
  OauthTotpLoginNotifier.new,
);
