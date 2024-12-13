import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'session_state.dart';

class SessionNotifier extends AsyncNotifier<SessionState> {
  @override
  FutureOr<SessionState> build() async {
    final session = await ref.read(sessionRepositoryProvider).getSession();
    return session != null
        ? SessionStateAuthenticated(token: session)
        : const SessionStateUnauthenticated();
  }

  Future<void> setSession({required String session}) async {
    state = const AsyncValue.loading();
    await ref.read(sessionRepositoryProvider).setSession(session: session);
    state = AsyncData(SessionStateAuthenticated(token: session));
  }

  Future<void> removeSession() async {
    await ref.read(sessionRepositoryProvider).deleteSession();
    state = const AsyncData(SessionStateUnauthenticated());
  }
}

final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
