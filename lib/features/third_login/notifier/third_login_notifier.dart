import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ThirdLoginResult { none, loading, progress, success, cancelled, error }

class ThirdLoginNotifier extends StateNotifier<ThirdLoginResult> {
  ThirdLoginNotifier(this._repository, [super.state = ThirdLoginResult.none]);

  final LoginRepository _repository;

  Future<void> authenticate() async {
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
}
