import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

enum ThirdLoginResult { none, progress, success, cancelled, error }

typedef ThirdLoginInfo = ({ThirdLoginResult result, String? token});

class ThirdLoginNotifier extends AutoDisposeAsyncNotifier<ThirdLoginInfo> {
  @override
  FutureOr<ThirdLoginInfo> build() {
    return (result: ThirdLoginResult.none, token: null);
  }

  Future<void> authenticateGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final googleResult = await repository.authenticateGoogle();

        final result = googleResult != null
            ? ThirdLoginResult.success
            : ThirdLoginResult.cancelled;
        return (result: result, token: googleResult);
      } on Exception catch (_) {
        return (result: ThirdLoginResult.error, token: null);
      }
    });
  }

  Future<void> authenticateApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final appleResult = await repository.authenticateApple();

        final result = appleResult != null
            ? ThirdLoginResult.success
            : ThirdLoginResult.error;
        return (result: result, token: appleResult);
      } on Exception catch (e) {
        if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
            return (result: ThirdLoginResult.cancelled, token: null);
          }
        }
        return (result: ThirdLoginResult.error, token: null);
      }
    });
  }

  Future<void> authenticateFacebook() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final facebookResult = await repository.authenticateFacebook();

      final result = switch (facebookResult['status'] as LoginStatus) {
        LoginStatus.success => ThirdLoginResult.success,
        LoginStatus.cancelled => ThirdLoginResult.cancelled,
        LoginStatus.failed => ThirdLoginResult.error,
        LoginStatus.operationInProgress => ThirdLoginResult.progress,
      };
      return (result: result, token: facebookResult['token'] as String?);
    });
  }

  Future<void> authenticateTwitter() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final twitterResult = await repository.authenticateTwitter();

        final result = switch (twitterResult['status'] as TwitterLoginStatus) {
          TwitterLoginStatus.loggedIn => ThirdLoginResult.success,
          TwitterLoginStatus.cancelledByUser => ThirdLoginResult.cancelled,
          TwitterLoginStatus.error => ThirdLoginResult.error,
        };
        return (result: result, token: twitterResult['token'] as String?);
      } on Exception catch (_) {
        return (result: ThirdLoginResult.error, token: null);
      }
    });
  }
}

final thirdLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<ThirdLoginNotifier, ThirdLoginInfo>(
      ThirdLoginNotifier.new,
    );
