import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/passcode_login/notifier/passcode_login_notifier.dart';
import 'package:flutter_login_types/features/passcode_login/notifier/passcode_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passcodeLoginNotifierProvider = StateNotifierProvider.autoDispose<
    PasscodeLoginNotifier, PasscodeLoginState>(
  (ref) => PasscodeLoginNotifier(ref.watch(loginRepositoryProvider)),
);
