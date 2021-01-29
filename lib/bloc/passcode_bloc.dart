import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:rxdart/rxdart.dart';

class PasscodeBloc with Validator implements BaseBloc {
  final repository = LoginRepository();

  final _page = BehaviorSubject<int>();

  final _phone = BehaviorSubject<String>();
  final _code = BehaviorSubject<String>();

  final _loading = PublishSubject<bool>();

  final _verified = PublishSubject<bool>();
  final _authenticated = PublishSubject<bool>();

  // Get data from Stream
  Stream<String> get phone => _phone.stream.transform(validateNumber);

  Stream<String> get code => _code.stream.transform(validatePassword);

  Stream<bool> get isValidPhone => phone.map((String value) => true);

  Stream<bool> get isValidPasscode => code.map((String value) => true);

  Stream<int> get page => _page.stream;

  Stream<bool> get isVerified => _verified.stream;

  Stream<bool> get isAuthenticated => _authenticated.stream;

  Stream<bool> get isLoading => _loading.stream;

  // Add data to Stream
  Function(String) get changePhone => _phone.sink.add;

  Function(String) get changeCode => _code.sink.add;

  Function(int) get changePage => _page.sink.add;

  // Functions
  void verifyPhone() async {
    _loading.sink.add(true);

    final token = await repository.verifyPhone(_phone.value);

    if (token.isEmpty) {
      _verified.sink.add(true);
      changePage(1);
    } else {
      _verified.sink.add(false);
    }

    _loading.sink.add(false);
    _clean(_verified);
  }

  void verifyCode() async {
    _loading.sink.add(true);

    final token = await repository.verifyCode(_code.value);

    if (token == 'MiToken') {
      _authenticated.sink.add(true);
      changePage(1);
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
    _phone.close();
    _code.close();

    _loading.close();
    _authenticated.close();
  }
}
