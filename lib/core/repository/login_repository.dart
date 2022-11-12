import 'package:flutter_login_types/core/client/login_client.dart';

class LoginRepository {
  LoginRepository(this._client);

  final LoginClient _client;

  Future<String?> authenticate(String username, String password) =>
      _client.authenticate(username, password);

  Future<String?> verifyPhone(String phone) => _client.verifyPhone(phone);

  Future<String?> verifyCode(String code) => _client.verifyCode(code);

  Future<String?> authenticateGoogle() => _client.authenticateGoogle();

  Future<String?> authenticateApple() => _client.authenticateApple();

  Future<Map<String, dynamic>> authenticateFacebook() =>
      _client.authenticateFacebook();

  Future<Map<String, dynamic>> authenticateTwitter() =>
      _client.authenticateTwitter();
}
