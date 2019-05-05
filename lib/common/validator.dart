import 'dart:async';

mixin Validator {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (_validateEmail(email))
      sink.add(email);
    else
      sink.addError("Enter a valid email");
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 4)
      sink.add(password);
    else
      sink.addError("Password must be at least 4 characters");
  });
}

bool _validateEmail(String value) {
  var regex =
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";

  RegExp regExp = RegExp(regex);

  return regExp.hasMatch(value);
}
