import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum PasscodeLogin { none, phone, passcode }

class PasscodeLoginNotifier extends AutoDisposeAsyncNotifier<PasscodeLogin> {
  @override
  FutureOr<PasscodeLogin> build() => PasscodeLogin.none;

  void restore() => state = const AsyncValue.data(PasscodeLogin.none);

  Future<void> verifyPhone(String phoneNumber) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final token = await repository.verifyPhone(phoneNumber);

      if (token != null && token.isEmpty) return PasscodeLogin.phone;
      throw Exception();
    });
  }

  Future<void> verifyCode(String passcode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final token = await repository.verifyCode(passcode);

      if (token != null && token == 'MiToken') return PasscodeLogin.passcode;
      throw Exception();
    });
  }
}

final passcodeLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<PasscodeLoginNotifier, PasscodeLogin>(
  PasscodeLoginNotifier.new,
);
