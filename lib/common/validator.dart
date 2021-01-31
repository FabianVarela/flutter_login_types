import 'dart:async';

mixin Validator {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isNotEmpty && _validateEmail(email)) {
      sink.add(email);
    } else {
      sink.addError('Ingrese un correo válido');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.isNotEmpty && password.length >= 4) {
      sink.add(password);
    } else {
      sink.addError('La contraseña debe ser mayor que 4 caracteres');
    }
  });

  final validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink) {
    if (number.isNotEmpty &&
        _validateNumber(number) &&
        _validatePhoneNumber(number)) {
      sink.add(number);
    } else {
      sink.addError('Ingrese un número válido');
    }
  });
}

bool _validateEmail(String value) => _isMatch(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    value);

bool _validateNumber(String value) => _isMatch(r'^[0-9]+$', value);

bool _validatePhoneNumber(String value) => _isMatch(r'^([0-9]){8,12}$', value);

bool _isMatch(String regex, String value, [bool caseSensitive = true]) =>
    RegExp(regex, caseSensitive: caseSensitive).hasMatch(value);
