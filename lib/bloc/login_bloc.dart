import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validator implements BaseBloc {
  final repository = LoginRepository();

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  final _loading = PublishSubject<bool>();
  final _authenticated = PublishSubject<bool>();

  // Get data from Stream
  Stream<String> get emailStream =>
      _emailSubject.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordSubject.stream.transform(validatePassword);

  Stream<bool> get isValidData =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Stream<bool> get isAuthenticated => _authenticated.stream;

  Stream<bool> get isLoading => _loading.stream;

  // Add data to Stream
  Function(String) get changeEmail => _emailSubject.sink.add;

  Function(String) get changePassword => _passwordSubject.sink.add;

  // Getters
  String get email => _emailSubject.value;

  String get password => _passwordSubject.value;

  // Functions
  void authenticate() async {
    _loading.sink.add(true);

    final token = await repository.authenticate(
        _emailSubject.value, _passwordSubject.value);

    if (token == 'MiToken') {
      _authenticated.sink.add(true);
    } else {
      _authenticated.sink.add(false);
    }

    _loading.sink.add(false);
    _clean(_authenticated);
  }

  void _clean(Subject subject) {
    Future.delayed(Duration(milliseconds: 200), () => subject.sink.add(null));
  }

  @override
  void dispose() {
    _emailSubject.close();
    _passwordSubject.close();

    _loading.close();
    _authenticated.close();
  }
}
