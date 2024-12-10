import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef SimpleLoginInfo = ({String token});

class SimpleLoginNotifier extends AutoDisposeAsyncNotifier<SimpleLoginInfo?> {
  @override
  FutureOr<SimpleLoginInfo?> build() => null;

  Future<void> authenticate({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final token = await ref
          .read(loginRepositoryProvider)
          .authenticate(username: email, password: password);

      if (token != null) return (token: token);
      throw Exception();
    });
  }
}

final simpleLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<SimpleLoginNotifier, SimpleLoginInfo?>(
  SimpleLoginNotifier.new,
);
