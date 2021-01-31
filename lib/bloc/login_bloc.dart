import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BaseBloc with Validator {
  final repository = LoginRepository();

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  final _authenticated = PublishSubject<bool>();

  // Get data from Stream
  Stream<String> get emailStream =>
      _emailSubject.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordSubject.stream.transform(validatePassword);

  Stream<bool> get isValidData =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Stream<bool> get isAuthenticated => _authenticated.stream;

  // Add data to Stream
  Function(String) get changeEmail => _emailSubject.sink.add;

  Function(String) get changePassword => _passwordSubject.sink.add;

  // Getters
  String get email => _emailSubject.value;

  String get password => _passwordSubject.value;

  // Functions
  void authenticate() async {
    loading.sink.add(true);

    final token = await repository.authenticate(
        _emailSubject.value, _passwordSubject.value);

    if (token == 'MiToken') {
      _authenticated.sink.add(true);
    } else {
      _authenticated.sink.add(false);
    }

    loading.sink.add(false);
    clean(_authenticated);
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();

    _authenticated.close();
    loading.close();
  }
}
