import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

enum ThirdLoginResult { none, loading, progress, success, cancelled, error }

class ThirdLoginNotifier extends StateNotifier<ThirdLoginResult> {
  ThirdLoginNotifier(this._repository, [super.state = ThirdLoginResult.none]);

  final LoginRepository _repository;

  Future<void> authenticateGoogle() async {
    state = ThirdLoginResult.loading;

    try {
      final googleResult = await _repository.authenticateGoogle();
      state = googleResult != null
          ? ThirdLoginResult.success
          : ThirdLoginResult.cancelled;
    } on Exception catch (_) {
      state = ThirdLoginResult.error;
    }
  }

  Future<void> authenticateApple() async {
    state = ThirdLoginResult.loading;

    try {
      final appleResult = await _repository.authenticateApple();
      state = appleResult != null
          ? ThirdLoginResult.success
          : ThirdLoginResult.error;
    } on Exception catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          state = ThirdLoginResult.cancelled;
          return;
        }
      }

      state = ThirdLoginResult.error;
    }
  }

  Future<void> authenticateFacebook() async {
    state = ThirdLoginResult.loading;

    final facebookResult = await _repository.authenticateFacebook();
    if (facebookResult.containsKey('status')) {
      state = switch (facebookResult['status'] as LoginStatus) {
        LoginStatus.success => ThirdLoginResult.success,
        LoginStatus.cancelled => ThirdLoginResult.cancelled,
        LoginStatus.failed => ThirdLoginResult.error,
        LoginStatus.operationInProgress => ThirdLoginResult.progress,
      };
    } else {
      state = ThirdLoginResult.error;
    }
  }

  Future<void> authenticateTwitter() async {
    try {
      state = ThirdLoginResult.loading;

      final twitterResult = await _repository.authenticateTwitter();
      state = switch (twitterResult['status'] as TwitterLoginStatus) {
        TwitterLoginStatus.loggedIn => ThirdLoginResult.success,
        TwitterLoginStatus.cancelledByUser => ThirdLoginResult.cancelled,
        TwitterLoginStatus.error => ThirdLoginResult.error,
      };
    } on Exception catch (_) {
      state = ThirdLoginResult.error;
    }
  }
}

final thirdLoginNotifierProvider =
    StateNotifierProvider.autoDispose<ThirdLoginNotifier, ThirdLoginResult>(
  (ref) => ThirdLoginNotifier(ref.watch(loginRepositoryProvider)),
);
