import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasscodeLoginFormNotifier extends StateNotifier<PasscodeLoginForm> {
  PasscodeLoginFormNotifier([super.state = const PasscodeLoginForm()]);

  void onChangePhone(String value) {
    state = state.copyWith(phoneInput: PhoneInputText.dirty(value));
  }
}

final passcodeFormNotifierProvider = StateNotifierProvider.autoDispose<
    PasscodeLoginFormNotifier, PasscodeLoginForm>(
  (ref) => PasscodeLoginFormNotifier(),
);
