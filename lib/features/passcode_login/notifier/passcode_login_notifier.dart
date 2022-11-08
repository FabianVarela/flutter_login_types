import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/features/passcode_login/notifier/passcode_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasscodeLoginNotifier extends StateNotifier<PasscodeLoginState> {
  PasscodeLoginNotifier(
    this._repository, [
    super.state = const PasscodeLoginState.initial(),
  ]);

  final LoginRepository _repository;

  Future<void> verifyPhone(String phoneNumber) async {
    state = const PasscodeLoginState.loading();
    final token = await _repository.verifyPhone(phoneNumber);
    state = token != null && token.isEmpty
        ? const PasscodeLoginState.success(phase: PasscodeLoginPhase.phone)
        : const PasscodeLoginState.error(phase: PasscodeLoginPhase.phone);
  }

  Future<void> verifyCode(String passcode) async {
    state = const PasscodeLoginState.loading();
    final token = await _repository.verifyCode(passcode);
    state = token != null && token == 'MiToken'
        ? const PasscodeLoginState.success(phase: PasscodeLoginPhase.passcode)
        : const PasscodeLoginState.error(phase: PasscodeLoginPhase.passcode);
  }
}
