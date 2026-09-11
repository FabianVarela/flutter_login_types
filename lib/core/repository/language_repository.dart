import 'package:flutter_login_types/core/client/preferences.dart';

class LanguageRepository {
  new({required this.preferences});

  final Preferences preferences;

  String? getLanguage() => preferences.getLanguage();

  Future<bool> setLanguage({required String language}) =>
      preferences.setLanguage(language: language);
}
