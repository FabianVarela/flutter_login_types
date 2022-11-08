import 'package:flutter_login_types/core/client/login_client.dart';
import 'package:flutter_login_types/core/client/preferences.dart';
import 'package:flutter_login_types/core/repository/language_repository.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
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
