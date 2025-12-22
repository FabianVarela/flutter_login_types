import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

enum ThirdLoginResult { none, progress, success, cancelled, error }

typedef ThirdLoginInfo = ({
  ThirdLoginResult result,
  String? token,
  LoginType? loginType,
});

class ThirdLoginNotifier extends AsyncNotifier<ThirdLoginInfo> {
  @override
  FutureOr<ThirdLoginInfo> build() {
    return (result: ThirdLoginResult.none, token: null, loginType: null);
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

        const loginType = LoginType.google;
        return (result: result, token: googleResult, loginType: loginType);
      } on Exception catch (_) {
        return (result: ThirdLoginResult.error, token: null, loginType: null);
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
        return (result: result, token: appleResult, loginType: LoginType.apple);
      } on Exception catch (e) {
        var result = ThirdLoginResult.error;
        if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
            result = ThirdLoginResult.cancelled;
          }
        }
        return (result: result, token: null, loginType: null);
      }
    });
  }

  Future<void> authenticateFacebook() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);
      final facebookResult = await repository.authenticateFacebook();

      final result = switch (facebookResult['status'] as LoginStatus) {
        .success => ThirdLoginResult.success,
        .cancelled => ThirdLoginResult.cancelled,
        .failed => ThirdLoginResult.error,
        .operationInProgress => ThirdLoginResult.progress,
      };

      final token = facebookResult['token'] as String?;
      return (result: result, token: token, loginType: LoginType.facebook);
    });
  }

  Future<void> authenticateTwitter() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final twitterResult = await repository.authenticateTwitter();

        final result = switch (twitterResult['status'] as TwitterLoginStatus) {
          .loggedIn => ThirdLoginResult.success,
          .cancelledByUser => ThirdLoginResult.cancelled,
          .error => ThirdLoginResult.error,
        };

        final token = twitterResult['token'] as String?;
        return (result: result, token: token, loginType: LoginType.twitter);
      } on Exception catch (_) {
        return (result: ThirdLoginResult.error, token: null, loginType: null);
      }
    });
  }
}

final thirdLoginNotifierProvider = AsyncNotifierProvider.autoDispose(
  ThirdLoginNotifier.new,
);
