import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/repository/login_repository.dart';

enum FacebookState { inProgress, cancelled, error }

class FacebookBloc extends BaseBloc {
  final _repository = LoginRepository();

  Future<FacebookState?> authenticate() async {
    FacebookState? result;
    loading.sink.add(true);

    try {
      await _repository.authenticateFacebook();
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          result = FacebookState.inProgress;
          break;
        case FacebookAuthErrorCode.CANCELLED:
          result = FacebookState.cancelled;
          break;
        case FacebookAuthErrorCode.FAILED:
          result = FacebookState.error;
          break;
      }
    }

    loading.sink.add(false);
    return result;
  }

  @override
  void dispose() {
    loading.close();
  }
}

final facebookBloc = FacebookBloc();
