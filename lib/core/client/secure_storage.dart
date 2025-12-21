import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage({required this.flutterSecureStorage});

  final FlutterSecureStorage flutterSecureStorage;

  static const _currentTokenKey = 'currentToken';
  static const _currentLoginKey = 'currentLogin';

  Future<String?> getCurrentToken() =>
      flutterSecureStorage.read(key: _currentTokenKey);

  Future<void> setCurrentToken({required String token}) =>
      flutterSecureStorage.write(key: _currentTokenKey, value: token);

  Future<String?> getCurrentLogin() =>
      flutterSecureStorage.read(key: _currentLoginKey);

  Future<void> setCurrentLogin({required String loginType}) =>
      flutterSecureStorage.write(key: _currentLoginKey, value: loginType);

  Future<void> clear() => flutterSecureStorage.deleteAll();
}
