import 'package:flutter_login_types/features/simple_login/forms/simple_login_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginFormNotifier extends StateNotifier<SimpleLoginForm> {
  SimpleLoginFormNotifier([super.state = const SimpleLoginForm()]);

  void onChangeEmail(String value) {
    state = state.copyWith(emailInput: EmailInputText.dirty(value));
  }

  void onChangePassword(String value) {
    state = state.copyWith(passwordInput: PasswordInputText.dirty(value));
  }
}

final loginFormNotifierProvider =
    StateNotifierProvider<SimpleLoginFormNotifier, SimpleLoginForm>(
  (ref) => SimpleLoginFormNotifier(),
);
