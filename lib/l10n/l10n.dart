import 'package:flutter/widgets.dart';
import 'package:flutter_login_types/l10n/gen/app_localizations.dart';

export 'package:flutter_login_types/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this);
}
