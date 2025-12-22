import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'session_state.dart';

class SessionNotifier extends AsyncNotifier<SessionState> {
  @override
  FutureOr<SessionState> build() async {
    final repository = ref.watch(sessionRepositoryProvider);

    final (token, loginType) = await (
      repository.getCurrentToken(),
      repository.getCurrentLogin(),
    ).wait;

    return switch ((token, loginType)) {
      (final String token, final String loginType) => SessionStateAuthenticated(
        token: token,
        loginType: loginType,
      ),
      _ => const SessionStateUnauthenticated(),
    };
  }

  Future<void> setSession({
    required ({String token, LoginType loginType}) sessionArgs,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sessionRepositoryProvider);
      await Future.wait([
        repository.setCurrentToken(token: sessionArgs.token),
        repository.setCurrentLogin(loginType: sessionArgs.loginType.name),
      ]);

      return SessionStateAuthenticated(
        token: sessionArgs.token,
        loginType: sessionArgs.loginType.name,
      );
    });
  }

  Future<void> logout() async {
    final currentStateValue = state.requireValue;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (currentStateValue is SessionStateAuthenticated) {
        final loginType = LoginType.values.byName(currentStateValue.loginType);
        await ref.read(logoutRepositoryProvider).logout(loginType);
      }

      await ref.read(sessionRepositoryProvider).clear();
      return const SessionStateUnauthenticated();
    });
  }
}

final sessionNotifierProvider = AsyncNotifierProvider(SessionNotifier.new);
