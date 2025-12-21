import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
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
    required String token,
    required String loginType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sessionRepositoryProvider);
      await Future.wait([
        repository.setCurrentToken(token: token),
        repository.setCurrentLogin(loginType: loginType),
      ]);
      return SessionStateAuthenticated(token: token, loginType: loginType);
    });
  }

  Future<void> clear() async {
    state = await AsyncValue.guard(() async {
      await ref.read(sessionRepositoryProvider).clear();
      return const SessionStateUnauthenticated();
    });
  }
}

final sessionNotifierProvider = AsyncNotifierProvider(SessionNotifier.new);
