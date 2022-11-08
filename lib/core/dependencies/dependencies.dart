import 'package:flutter/material.dart';
import 'package:flutter_login_types/client/preferences.dart';
import 'package:flutter_login_types/core/notifiers/language_notifier.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('You must implement SharedPreferences provider');
});

final preferencesProvider = Provider<Preferences>((_) {
  throw UnimplementedError('You must implement Preferences provider');
});

final languageRepositoryProvider = Provider<LanguageRepository>((_) {
  throw UnimplementedError('You must implement LanguageRepository provider');
});

final languageNotifierProvider =
    StateNotifierProvider.autoDispose<LanguageNotifier, Locale?>(
  (ref) => LanguageNotifier(ref.read(languageRepositoryProvider)),
);