import 'package:flutter_login_types/features/simple_login/forms/simple_login_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginFormNotifier extends AutoDisposeNotifier<SimpleLoginForm> {
  @override
  SimpleLoginForm build() => const SimpleLoginForm();

  void onChangeEmail({required String value}) {
    state = state.copyWith(emailInput: EmailInputText.dirty(value));
  }

  void onChangePassword({required String value}) {
    state = state.copyWith(passwordInput: PasswordInputText.dirty(value));
  }
}

final loginFormNotifierProvider =
    NotifierProvider.autoDispose<SimpleLoginFormNotifier, SimpleLoginForm>(
  SimpleLoginFormNotifier.new,
);
