import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'session_state.dart';

class SessionNotifier extends ChangeNotifier {
  SessionNotifier({required this.repository}) {
    init();
  }

  final SessionRepository repository;

  SessionState _session = const SessionStateInitial();

  SessionState get session => _session;

  Future<void> init() async {
    final session = await repository.getSession();
    _session = session != null
        ? SessionStateAuthenticated(token: session)
        : const SessionStateUnauthenticated();

    notifyListeners();
  }

  Future<void> setSession({required String session}) async {
    _session = const SessionStateLoading();
    notifyListeners();

    await repository.setSession(session: session);

    _session = SessionStateAuthenticated(token: session);
    notifyListeners();
  }

  Future<void> removeSession() async {
    await repository.deleteSession();
    _session = const SessionStateUnauthenticated();

    notifyListeners();
  }
}

final sessionNotifierProvider = ChangeNotifierProvider<SessionNotifier>(
  (ref) => SessionNotifier(repository: ref.watch(sessionRepositoryProvider)),
);
