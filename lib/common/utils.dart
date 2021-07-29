import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:login_bloc/common/model/text_field_validator.dart';

class Utils {
  static String? getTextValidator(BuildContext ctx, TextValidator? validator) {
    final localizations = AppLocalizations.of(ctx)!;

    switch (validator) {
      case TextValidator.empty:
        return localizations.emptyValidation;
      case TextValidator.email:
        return localizations.emailValidation;
      case TextValidator.password:
        return localizations.passwordValidation;
      case TextValidator.numeric:
        return localizations.numberValidation;
      default:
        return null;
    }
  }
}
