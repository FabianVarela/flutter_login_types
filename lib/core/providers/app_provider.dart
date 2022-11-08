import 'package:flutter_login_types/client/login_client.dart';
import 'package:flutter_login_types/client/preferences.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:flutter_login_types/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppProvider {
  AppProvider({
    required this.preferences,
    required this.loginClient,
    required this.languageRepository,
    required this.loginRepository,
  });

  final Provider<Preferences> preferences;
  final Provider<LoginClient> loginClient;
  final Provider<LanguageRepository> languageRepository;
  final Provider<LoginRepository> loginRepository;
}
