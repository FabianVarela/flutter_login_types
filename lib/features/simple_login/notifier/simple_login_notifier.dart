import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginNotifier extends AutoDisposeAsyncNotifier<bool?> {
  @override
  FutureOr<bool?> build() => null;

  Future<void> authenticate(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final token = await repository.authenticate(
        username: email,
        password: password,
      );

      if (token != null && token == 'MiToken') return true;
      throw Exception();
    });
  }
}

final simpleLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<SimpleLoginNotifier, bool?>(
  SimpleLoginNotifier.new,
);
