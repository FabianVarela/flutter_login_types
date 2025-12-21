import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final language = ref.watch(languageRepositoryProvider).getLanguage();
    if (language != null) return Locale(language);
    return null;
  }

  Future<void> setLanguage({required String language}) async {
    final repository = ref.read(languageRepositoryProvider);
    await repository.setLanguage(language: language);

    state = Locale(language);
  }
}

final languageNotifierProvider = NotifierProvider.autoDispose(
  LanguageNotifier.new,
);
