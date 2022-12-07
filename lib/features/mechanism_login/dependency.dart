import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/mechanism_login/notifier/mechanism_login_notifier.dart';
import 'package:flutter_login_types/features/mechanism_login/notifier/mechanism_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mechanismLoginNotifierProvider = StateNotifierProvider.autoDispose<
    MechanismLoginNotifier, MechanismLoginState>(
  (ref) => MechanismLoginNotifier(ref.watch(loginRepositoryProvider)),
);
