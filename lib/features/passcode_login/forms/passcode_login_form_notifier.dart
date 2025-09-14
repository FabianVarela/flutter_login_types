import 'package:flutter_login_types/features/passcode_login/forms/passcode_login_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasscodeLoginFormNotifier extends Notifier<PasscodeLoginForm> {
  @override
  PasscodeLoginForm build() => const PasscodeLoginForm();

  void onChangePhone({required String value}) {
    state = state.copyWith(phoneInput: PhoneInputText.dirty(value));
  }
}

final passcodeFormNotifierProvider = NotifierProvider.autoDispose(
  PasscodeLoginFormNotifier.new,
);
