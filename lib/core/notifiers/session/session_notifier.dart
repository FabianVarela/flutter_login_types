import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SessionNotifier extends AutoDisposeAsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async {
    return await ref.read(sessionRepositoryProvider).getSession();
  }

  Future<void> setSession({required String session}) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sessionRepositoryProvider);
      await repository.setSession(session: session);

      return session;
    });
  }

  Future<void> removeSession() async {
    state = await AsyncValue.guard(() async {
      await ref.read(sessionRepositoryProvider).deleteSession();
      return null;
    });
  }
}

final sessionNotifierProvider =
    AsyncNotifierProvider.autoDispose<SessionNotifier, String?>(
  SessionNotifier.new,
);
