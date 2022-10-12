import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_bloc/bloc/base_bloc.dart';
import 'package:rxdart/subjects.dart';

class BiometricBloc extends BaseBloc {
  final _authentication = LocalAuthentication();

  final _hasBiometricSubject = BehaviorSubject<bool>();

  final _biometricList = BehaviorSubject<List<BiometricType>>();

  Stream<bool> get hasBiometricStream => _hasBiometricSubject.stream;

  Stream<List<BiometricType>> get biometricListStream => _biometricList.stream;

  Future<void> checkBiometric() async {
    try {
      final hasBiometric = await _authentication.canCheckBiometrics;
      _hasBiometricSubject.sink.add(hasBiometric);
    } on PlatformException catch (e) {
      print(e);
      _hasBiometricSubject.sink.add(false);
    }
  }

  Future<void> getListBiometric() async {
    try {
      final biometricList = await _authentication.getAvailableBiometrics();
      _biometricList.sink.add(biometricList);
    } on PlatformException catch (e) {
      print(e);
      _biometricList.sink.add([]);
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      final isAuthorized = await _authentication.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(stickyAuth: true),
      );
      return isAuthorized;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    _hasBiometricSubject.close();
    _biometricList.close();
  }
}

final biometricBloc = BiometricBloc();
