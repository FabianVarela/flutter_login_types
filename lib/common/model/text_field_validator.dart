enum TextValidator { empty, text, email, password, numeric }

class TextFieldValidator {
  TextFieldValidator({this.text, this.validator});

  final String? text;
  final TextValidator? validator;
}
