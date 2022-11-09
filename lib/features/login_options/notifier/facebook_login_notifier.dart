import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FacebookLoginResult { none, loading, progress, success, cancelled, error }

class FacebookLoginNotifier extends StateNotifier<FacebookLoginResult> {
  FacebookLoginNotifier(
    this._repository, [
    super.state = FacebookLoginResult.none,
  ]);

  final LoginRepository _repository;

  Future<void> authenticate() async {
    state = FacebookLoginResult.loading;

    final facebookResult = await _repository.authenticateFacebook();
    if (facebookResult.containsKey('status')) {
      switch (facebookResult['status'] as LoginStatus) {
        case LoginStatus.success:
          state = FacebookLoginResult.success;
          break;
        case LoginStatus.cancelled:
          state = FacebookLoginResult.cancelled;
          break;
        case LoginStatus.failed:
          state = FacebookLoginResult.error;
          break;
        case LoginStatus.operationInProgress:
          state = FacebookLoginResult.progress;
          break;
      }
    } else {
      state = FacebookLoginResult.error;
    }
  }
}
