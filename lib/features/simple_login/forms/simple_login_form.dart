import 'package:formz/formz.dart';

enum EmailInputValidator { invalid, empty }

class EmailInputText extends FormzInput<String, EmailInputValidator> {
  const new pure() : super.pure('');

  const new dirty([super.value = '']) : super.dirty();

  @override
  EmailInputValidator? validator(String value) {
    if (isPure) return null;
    if (value.isEmpty) return .empty;

    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!regex.hasMatch(value)) return .invalid;

    return null;
  }
}

enum PasswordInputValidator { invalid, empty }

class PasswordInputText extends FormzInput<String, PasswordInputValidator> {
  const new pure() : super.pure('');

  const new dirty([super.value = '']) : super.dirty();

  @override
  PasswordInputValidator? validator(String value) {
    if (isPure) return null;
    if (value.isEmpty) return PasswordInputValidator.empty;

    if (value.isNotEmpty && value.length < 4) {
      return PasswordInputValidator.invalid;
    }

    return null;
  }
}

class SimpleLoginForm with FormzMixin {
  const new({
    this.emailInput = const EmailInputText.pure(),
    this.passwordInput = const PasswordInputText.pure(),
  });

  final EmailInputText emailInput;
  final PasswordInputText passwordInput;

  SimpleLoginForm copyWith({
    EmailInputText? emailInput,
    PasswordInputText? passwordInput,
  }) {
    return SimpleLoginForm(
      emailInput: emailInput ?? this.emailInput,
      passwordInput: passwordInput ?? this.passwordInput,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [emailInput, passwordInput];
}
