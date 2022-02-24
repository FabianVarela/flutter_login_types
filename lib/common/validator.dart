import 'dart:async';

import 'package:login_bloc/common/model/text_field_validator.dart';

mixin Validator {
  final checkEmail = StreamTransformer<String, TextFieldValidator>.fromHandlers(
    handleData: (email, sink) {
      if (email.isNotEmpty && _validateEmail(email)) {
        sink.add(TextFieldValidator(text: email));
      } else {
        sink.addError(TextFieldValidator(validator: TextValidator.email));
      }
    },
  );

  final checkPass = StreamTransformer<String, TextFieldValidator>.fromHandlers(
    handleData: (password, sink) {
      if (password.isNotEmpty && password.length >= 4) {
        sink.add(TextFieldValidator(text: password));
      } else {
        sink.addError(TextFieldValidator(validator: TextValidator.password));
      }
    },
  );

  final checkNum = StreamTransformer<String, TextFieldValidator>.fromHandlers(
    handleData: (number, sink) {
      final isNumber = _validateNumber(number);
      final isPhoneNumber = _validatePhoneNumber(number);

      if (number.isNotEmpty && isNumber && isPhoneNumber) {
        sink.add(TextFieldValidator(text: number));
      } else {
        sink.addError(TextFieldValidator(validator: TextValidator.numeric));
      }
    },
  );
}

bool _validateEmail(String value) => _isMatch(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      value,
    );

bool _validateNumber(String value) => _isMatch(r'^[0-9]+$', value);

bool _validatePhoneNumber(String value) => _isMatch(r'^([0-9]){8,12}$', value);

bool _isMatch(String regex, String value, [bool caseSensitive = true]) =>
    RegExp(regex, caseSensitive: caseSensitive).hasMatch(value);
