import 'package:flutter/material.dart';
import 'package:flutter_login_types/common/model/text_field_validator.dart';
import 'package:flutter_login_types/l10n/l10n.dart';

class Utils {
  static String? getTextValidator(BuildContext ctx, TextValidator? validator) {
    final localization = ctx.localizations;

    switch (validator) {
      case TextValidator.empty:
        return localization.emptyValidation;
      case TextValidator.email:
        return localization.emailValidation;
      case TextValidator.password:
        return localization.passwordValidation;
      case TextValidator.numeric:
        return localization.numberValidation;
      default:
        return null;
    }
  }
}
