import 'package:flutter_login_types/client/preferences.dart';

class LanguageRepository {
  final _preferences = Preferences();

  Future<String?> getLanguage() => _preferences.getLanguage();

  Future<bool> setLanguage(String language) =>
      _preferences.setLanguage(language);
}
