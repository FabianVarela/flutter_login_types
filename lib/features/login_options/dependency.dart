import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/features/login_options/notifier/facebook_login_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final facebookLoginNotifierProvider = StateNotifierProvider.autoDispose<
    FacebookLoginNotifier, FacebookLoginResult>(
  (ref) => FacebookLoginNotifier(ref.watch(loginRepositoryProvider)),
);
