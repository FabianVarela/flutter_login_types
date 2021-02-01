import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:login_bloc/common/validator.dart';
import 'package:login_bloc/repository/login_repository.dart';
import 'package:rxdart/rxdart.dart';

enum PasscodeStatus {
  verified,
  authenticated,
  verifiedError,
  authenticatedError,
  none,
}

class PasscodeBloc extends BaseBloc with Validator {
  final _repository = LoginRepository();

  final _pageSubject = BehaviorSubject<int>();

  final _phoneSubject = BehaviorSubject<String>();
  final _codeSubject = BehaviorSubject<String>();

  final _passcodeStatusSubject = BehaviorSubject<PasscodeStatus>();

  PasscodeBloc() {
    _pageSubject.sink.add(0);
  }

  // Get data from Stream
  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(validateNumber);

  Stream<String> get codeStream =>
      _codeSubject.stream.transform(validatePassword);

  Stream<bool> get isValidPhone => phoneStream.map((String value) => true);

  Stream<bool> get isValidPasscode => codeStream.map((String value) => true);

  Stream<int> get pageStream => _pageSubject.stream;

  Stream<PasscodeStatus> get passcodeStatusStream =>
      _passcodeStatusSubject.stream;

  // Add data to Stream
  Function(String) get changePhone => _phoneSubject.sink.add;

  Function(String) get changeCode => _codeSubject.sink.add;

  Function(int) get changePage => _pageSubject.sink.add;

  // Getter
  String get phone => _phoneSubject.value;

  int get page => _pageSubject.value;

  // Functions
  void verifyPhone() async {
    loading.sink.add(true);

    final token = await _repository.verifyPhone(_phoneSubject.value);

    if (token.isEmpty) {
      _passcodeStatusSubject.sink.add(PasscodeStatus.verified);
      changePage(1);
    } else {
      _passcodeStatusSubject.sink.add(PasscodeStatus.verifiedError);
    }

    loading.sink.add(false);
    clean(_passcodeStatusSubject, value: PasscodeStatus.none);
  }

  void verifyCode() async {
    loading.sink.add(true);

    final token = await _repository.verifyCode(_codeSubject.value);

    if (token == 'MiToken') {
      _passcodeStatusSubject.sink.add(PasscodeStatus.authenticated);
    } else {
      _passcodeStatusSubject.sink.add(PasscodeStatus.authenticatedError);
    }

    loading.sink.add(false);
    clean(_passcodeStatusSubject, value: PasscodeStatus.none);
  }

  @override
  void dispose() {
    _phoneSubject.close();
    _codeSubject.close();
    _passcodeStatusSubject.close();
    loading.close();
  }
}
