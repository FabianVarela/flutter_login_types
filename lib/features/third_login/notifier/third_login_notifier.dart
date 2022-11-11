import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum ThirdLoginResult { none, loading, progress, success, cancelled, error }

class ThirdLoginNotifier extends StateNotifier<ThirdLoginResult> {
  ThirdLoginNotifier(this._repository, [super.state = ThirdLoginResult.none]);

  final LoginRepository _repository;

  Future<void> authenticateFacebook() async {
    state = ThirdLoginResult.loading;

    final facebookResult = await _repository.authenticateFacebook();
    if (facebookResult.containsKey('status')) {
      switch (facebookResult['status'] as LoginStatus) {
        case LoginStatus.success:
          state = ThirdLoginResult.success;
          break;
        case LoginStatus.cancelled:
          state = ThirdLoginResult.cancelled;
          break;
        case LoginStatus.failed:
          state = ThirdLoginResult.error;
          break;
        case LoginStatus.operationInProgress:
          state = ThirdLoginResult.progress;
          break;
      }
    } else {
      state = ThirdLoginResult.error;
    }
  }

  Future<void> authenticateApple() async {
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

  Future<void> authenticateGoogle() async {
    try {
      final credentialId = await _repository.authenticateGoogle();

      state = credentialId != null
          ? ThirdLoginResult.success
          : ThirdLoginResult.cancelled;
    } on Exception catch (_) {
      state = ThirdLoginResult.error;
    }
  }
}
