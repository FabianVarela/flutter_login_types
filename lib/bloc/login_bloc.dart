import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with Validator implements BaseBloc {
  String token;
  final repository = LoginRepository();

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  final _loading = PublishSubject<bool>();
  final _authenticated = PublishSubject<bool>();

  // Get data from Stream
  Stream<String> get email => _email.stream.transform(validateEmail);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get isValidData =>
      Observable.combineLatest2(email, password, (e, p) => true);

  Observable<bool> get isAuthenticated => _authenticated.stream;

  Observable<bool> get isLoading => _loading.stream;

  // Add data to Stream
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  // Functions
  void authenticate() async {
    _loading.sink.add(true);

    token = await repository.authenticate(_email.value, _password.value);

    if (token == "MiToken")
      _authenticated.sink.add(true);
    else
      _authenticated.sink.add(false);

    _loading.sink.add(false);
  }

  @override
  void dispose() {
    _email.close();
    _password.close();

    _loading.close();
    _authenticated.close();
  }
}
