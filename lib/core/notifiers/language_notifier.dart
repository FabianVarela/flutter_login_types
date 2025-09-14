import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageNotifier extends AsyncNotifier<Locale?> {
  @override
  FutureOr<Locale?> build() async {
    final language = await ref.read(languageRepositoryProvider).getLanguage();
    if (language != null) return Locale(language);
    return null;
  }

  Future<void> setLanguage({required String language}) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(languageRepositoryProvider);
      await repository.setLanguage(language: language);

      return Locale(language);
    });
  }
}

final languageNotifierProvider = AsyncNotifierProvider.autoDispose(
  LanguageNotifier.new,
);
