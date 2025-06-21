import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum PasscodeMode { none, phone, passcode }

typedef PasscodeInfo = ({PasscodeMode mode, String? token});

class PasscodeLoginNotifier extends AutoDisposeAsyncNotifier<PasscodeInfo> {
  @override
  FutureOr<PasscodeInfo> build() => (mode: PasscodeMode.none, token: null);

  void restore() {
    state = const AsyncValue.data((mode: PasscodeMode.none, token: null));
  }

  Future<void> verifyPhone({required String phoneNumber}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final verified = await ref
          .read(loginRepositoryProvider)
          .verifyPhone(phone: phoneNumber);

      if (verified != null && verified.isEmpty) {
        return (mode: PasscodeMode.phone, token: null);
      }
      throw Exception();
    });
  }

  Future<void> verifyCode({required String passcode}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final token = await ref
          .read(loginRepositoryProvider)
          .verifyCode(passcode: passcode);

      if (token != null) return (mode: PasscodeMode.passcode, token: token);
      throw Exception();
    });
  }
}

final passcodeLoginNotifierProvider = AsyncNotifierProvider.autoDispose(
  PasscodeLoginNotifier.new,
);
