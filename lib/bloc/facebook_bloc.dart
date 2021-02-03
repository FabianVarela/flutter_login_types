import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:rxdart/subjects.dart';

class FacebookBloc extends BaseBloc {
  final _repository = LoginRepository();

  final _message = BehaviorSubject<String>();

  Stream<String> get message => _message.stream;

  void authenticate() async {
    loading.sink.add(true);

    try {
      await _repository.authenticateFacebook();
      _message.sink.add('');
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          _message.sink.add('En progreso, por favor espere');
          break;
        case FacebookAuthErrorCode.CANCELLED:
          _message.sink.add('Cancelado');
          break;
        case FacebookAuthErrorCode.FAILED:
          _message.sink.add('Error al iniciar sesión');
          break;
      }
    }

    loading.sink.add(false);
    clean(_message);
  }

  @override
  void dispose() {
    _message.close();
    loading.close();
  }
}
