import 'package:formz/formz.dart';

enum PhoneInputValidation { invalid, empty }

class PhoneInputText extends FormzInput<String, PhoneInputValidation> {
  const PhoneInputText.pure() : super.pure('');

  const PhoneInputText.dirty([super.value = '']) : super.dirty();

  @override
  PhoneInputValidation? validator(String value) {
    if (isPure) return null;
    if (value.isEmpty) return .empty;

    final regex = RegExp(r'^([0-9]){8,12}$');
    if (!regex.hasMatch(value)) return .invalid;

    return null;
  }
}

class PasscodeLoginForm with FormzMixin {
  const PasscodeLoginForm({this.phoneInput = const PhoneInputText.pure()});

  final PhoneInputText phoneInput;

  PasscodeLoginForm copyWith({PhoneInputText? phoneInput}) {
    return PasscodeLoginForm(phoneInput: phoneInput ?? this.phoneInput);
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [phoneInput];
}
