import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final _preferences = SharedPreferences.getInstance();

  static const _languageKey = 'language';

  Future<String?> getLanguage() async {
    final prefs = await _preferences;
    return prefs.getString(_languageKey);
  }

  Future<bool> setLanguage(String language) async {
    final prefs = await _preferences;
    return prefs.setString(_languageKey, language);
  }
}
