import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const _languageKey = 'language';

  String? getLanguage() => sharedPreferences.getString(_languageKey);

  Future<bool> setLanguage({required String language}) =>
      sharedPreferences.setString(_languageKey, language);
}
