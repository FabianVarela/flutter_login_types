import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:rxdart/rxdart.dart';

class PasscodeBloc extends BaseBloc with Validator {
  final repository = LoginRepository();

  final _page = BehaviorSubject<int>();

  final _phoneSubject = BehaviorSubject<String>();
  final _codeSubject = BehaviorSubject<String>();

  final _verified = PublishSubject<bool>();
  final _authenticated = PublishSubject<bool>();

  // Get data from Stream
  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(validateNumber);

  Stream<String> get codeStream =>
      _codeSubject.stream.transform(validatePassword);

  Stream<bool> get isValidPhone => phoneStream.map((String value) => true);

  Stream<bool> get isValidPasscode => codeStream.map((String value) => true);

  Stream<int> get page => _page.stream;

  Stream<bool> get isVerified => _verified.stream;

  Stream<bool> get isAuthenticated => _authenticated.stream;

  // Add data to Stream
  Function(String) get changePhone => _phoneSubject.sink.add;

  Function(String) get changeCode => _codeSubject.sink.add;

  Function(int) get changePage => _page.sink.add;

  // Getter
  String get phone => _phoneSubject.value;

  // Functions
  void verifyPhone() async {
    loading.sink.add(true);

    final token = await repository.verifyPhone(_phoneSubject.value);

    if (token.isEmpty) {
      _verified.sink.add(true);
      changePage(1);
    } else {
      _verified.sink.add(false);
    }

    loading.sink.add(false);
    clean(_verified);
  }

  void verifyCode() async {
    loading.sink.add(true);

    final token = await repository.verifyCode(_codeSubject.value);

    if (token == 'MiToken') {
      _authenticated.sink.add(true);
      changePage(1);
    } else {
      _authenticated.sink.add(false);
    }

    loading.sink.add(false);
    clean(_authenticated);
  }

  @override
  void dispose() {
    _phoneSubject.close();
    _codeSubject.close();

    _authenticated.close();
    loading.close();
  }
}
