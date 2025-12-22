import 'package:flutter_login_types/core/client/logout_client.dart';
import 'package:flutter_login_types/core/client/secure_storage.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';

class SessionRepository {
  SessionRepository({required this.secureStorage, required this.client});

  final SecureStorage secureStorage;
  final LogoutClient client;

  Future<String?> getCurrentToken() => secureStorage.getCurrentToken();

  Future<void> setCurrentToken({required String token}) =>
      secureStorage.setCurrentToken(token: token);

  Future<String?> getCurrentLogin() => secureStorage.getCurrentLogin();

  Future<void> setCurrentLogin({required String loginType}) =>
      secureStorage.setCurrentLogin(loginType: loginType);

  Future<void> clear() => secureStorage.clear();

  Future<void> logout({required LoginType loginType, String? token}) {
    return client.logout(loginType: loginType, token: token);
  }
}
