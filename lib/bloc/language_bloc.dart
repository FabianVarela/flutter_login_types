import 'package:flutter/material.dart';
import 'package:flutter_login_types/bloc/base_bloc.dart';
import 'package:flutter_login_types/repository/language_repository.dart';
import 'package:rxdart/rxdart.dart';

class LanguageBloc extends BaseBloc {
  final _repository = LanguageRepository();

  final _localeSubject = BehaviorSubject<Locale?>();

  Stream<Locale?> get localeStream => _localeSubject.stream.distinct();

  Future<void> getLanguage() async {
    final language = await _repository.getLanguage();
    if (language != null) {
      _localeSubject.sink.add(Locale(language));
    }
  }

  Future<void> setLanguage(String language) async {
    await _repository.setLanguage(language);
    _localeSubject.sink.add(Locale(language));
  }

  @override
  void dispose() {
    _localeSubject.close();
  }
}

final languageBloc = LanguageBloc();
