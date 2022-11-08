import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/simple_login/notifier/simple_login_notifier.dart';
import 'package:flutter_login_types/features/simple_login/notifier/simple_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final simpleLoginNotifierProvider =
    StateNotifierProvider.autoDispose<SimpleLoginNotifier, SimpleLoginState>(
  (ref) => SimpleLoginNotifier(ref.watch(loginRepositoryProvider)),
);
