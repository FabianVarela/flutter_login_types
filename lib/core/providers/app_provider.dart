import 'package:flutter_login_types/client/preferences.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppProvider {
  AppProvider({
    required this.preferences,
    required this.languageRepository,
  });

  final Provider<Preferences> preferences;
  final Provider<LanguageRepository> languageRepository;
}
