import 'package:flutter_login_types/core/client/secure_storage.dart';

class SessionRepository {
  SessionRepository({required this.secureStorage});

  final SecureStorage secureStorage;

  Future<String?> getCurrentToken() => secureStorage.getCurrentToken();

  Future<void> setCurrentToken({required String token}) =>
      secureStorage.setCurrentToken(token: token);

  Future<String?> getCurrentLogin() => secureStorage.getCurrentLogin();

  Future<void> setCurrentLogin({required String loginType}) =>
      secureStorage.setCurrentLogin(loginType: loginType);

  Future<void> clear() => secureStorage.clear();
}
