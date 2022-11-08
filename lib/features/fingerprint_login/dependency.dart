import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/fingerprint_login/notifier/fingerprint_login_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localAuthNotifierProvider =
    StateNotifierProvider.autoDispose<LocalAuthNotifier, LocalAuthOption>(
  (ref) => LocalAuthNotifier(ref.watch(localAuthenticationProvider)),
);
