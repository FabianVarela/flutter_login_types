import 'package:flutter_login_types/client/preferences.dart';

class LanguageRepository {
  LanguageRepository(this._preferences);

  final Preferences _preferences;

  Future<String?> getLanguage() => _preferences.getLanguage();

  Future<bool> setLanguage(String language) =>
      _preferences.setLanguage(language);
}
