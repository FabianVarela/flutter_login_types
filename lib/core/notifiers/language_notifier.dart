import 'package:flutter/material.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageNotifier extends StateNotifier<Locale?> {
  LanguageNotifier(this._repository, [super.state]);

  final LanguageRepository _repository;

  Future<void> getLanguage() async {
    final language = await _repository.getLanguage();
    if (language != null) state = Locale(language);
  }

  Future<void> setLanguage(String language) async {
    await _repository.setLanguage(language);
    state = Locale(language);
  }
}
