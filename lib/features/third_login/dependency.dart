import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/third_login/notifier/third_login_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final thirdLoginNotifierProvider =
    StateNotifierProvider.autoDispose<ThirdLoginNotifier, ThirdLoginResult>(
  (ref) => ThirdLoginNotifier(ref.watch(loginRepositoryProvider)),
);
