import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

enum ThirdLoginResult { none, progress, success, cancelled, error }

class ThirdLoginNotifier extends AutoDisposeAsyncNotifier<ThirdLoginResult> {
  @override
  FutureOr<ThirdLoginResult> build() => ThirdLoginResult.none;

  Future<void> authenticateGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final googleResult = await repository.authenticateGoogle();

        return googleResult != null
            ? ThirdLoginResult.success
            : ThirdLoginResult.cancelled;
      } on Exception catch (_) {
        return ThirdLoginResult.error;
      }
    });
  }

  Future<void> authenticateApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final appleResult = await repository.authenticateApple();

        return appleResult != null
            ? ThirdLoginResult.success
            : ThirdLoginResult.error;
      } on Exception catch (e) {
        if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
            return ThirdLoginResult.cancelled;
          }
        }
        return ThirdLoginResult.error;
      }
    });
  }

  Future<void> authenticateFacebook() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final facebookResult = await repository.authenticateFacebook();

      if (facebookResult.containsKey('status')) {
        return switch (facebookResult['status'] as LoginStatus) {
          LoginStatus.success => ThirdLoginResult.success,
          LoginStatus.cancelled => ThirdLoginResult.cancelled,
          LoginStatus.failed => ThirdLoginResult.error,
          LoginStatus.operationInProgress => ThirdLoginResult.progress,
        };
      } else {
        return ThirdLoginResult.error;
      }
    });
  }

  Future<void> authenticateTwitter() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final twitterResult = await repository.authenticateTwitter();

        return switch (twitterResult['status'] as TwitterLoginStatus) {
          TwitterLoginStatus.loggedIn => ThirdLoginResult.success,
          TwitterLoginStatus.cancelledByUser => ThirdLoginResult.cancelled,
          TwitterLoginStatus.error => ThirdLoginResult.error,
        };
      } on Exception catch (_) {
        return ThirdLoginResult.error;
      }
    });
  }
}

final thirdLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<ThirdLoginNotifier, ThirdLoginResult>(
  ThirdLoginNotifier.new,
);
