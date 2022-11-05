import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/bloc/base_bloc.dart';
import 'package:flutter_login_types/repository/login_repository.dart';

enum FacebookState { inProgress, cancelled, error }

class FacebookBloc extends BaseBloc {
  final _repository = LoginRepository();

  Future<FacebookState?> authenticate() async {
    FacebookState? result;
    loading.sink.add(true);

    final facebookResult = await _repository.authenticateFacebook();

    if (facebookResult.containsKey('status')) {
      switch (facebookResult['status'] as LoginStatus) {
        case LoginStatus.cancelled:
          result = FacebookState.cancelled;
          break;
        case LoginStatus.failed:
          result = FacebookState.error;
          break;
        case LoginStatus.operationInProgress:
          result = FacebookState.inProgress;
          break;
        default:
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
