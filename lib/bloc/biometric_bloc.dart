import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:rxdart/subjects.dart';

class BiometricBloc extends BaseBloc {
  final _authentication = LocalAuthentication();

  final _messageSubject = BehaviorSubject<String>();

  final _hasBiometricSubject = BehaviorSubject<bool>();

  final _biometricList = BehaviorSubject<List<BiometricType>>();

  Stream<String> get messageStream => _messageSubject.stream;

  Stream<bool> get hasBiometricStream => _hasBiometricSubject.stream;

  Stream<List<BiometricType>> get biometricListStream => _biometricList.stream;

  Future<void> checkBiometric() async {
    try {
      final hasBiometric = await _authentication.canCheckBiometrics;
      _hasBiometricSubject.sink.add(hasBiometric);
      print(hasBiometric);
    } on PlatformException catch (e) {
      _messageSubject.sink.add(e.message);
      print(e);
    }

    clean(_messageSubject, value: '');
  }

  Future<void> getListBiometric() async {
    try {
      final biometricList = await _authentication.getAvailableBiometrics();
      _biometricList.sink.add(biometricList);
      print(biometricList);
    } on PlatformException catch (e) {
      _messageSubject.sink.add(e.message);
      print(e);
    }

    clean(_messageSubject);
  }

  void authenticate() async {
    try {
      final isAuthorized = await _authentication.authenticateWithBiometrics(
        localizedReason: 'Coloca tu huella o cara para iniciar',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      _messageSubject.sink.add(isAuthorized ? '' : 'No autorizado');
    } on PlatformException catch (e) {
      _messageSubject.sink.addError(e);
      print(e);
    }

    clean(_messageSubject);
  }

  @override
  void dispose() {
    _messageSubject.close();
    _hasBiometricSubject.close();
    _biometricList.close();
  }
}
