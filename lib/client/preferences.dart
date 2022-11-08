import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static const _languageKey = 'language';

  Future<String?> getLanguage() async {
    return _sharedPreferences.getString(_languageKey);
  }

  Future<bool> setLanguage(String language) async {
    return _sharedPreferences.setString(_languageKey, language);
  }
}
