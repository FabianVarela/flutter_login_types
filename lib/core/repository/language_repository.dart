import 'package:flutter_login_types/core/client/preferences.dart';

class LanguageRepository {
  LanguageRepository({required this.preferences});

  final Preferences preferences;

  Future<String?> getLanguage() => preferences.getLanguage();

  Future<bool> setLanguage({required String language}) =>
      preferences.setLanguage(language: language);
}
