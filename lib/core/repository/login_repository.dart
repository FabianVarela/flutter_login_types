import 'package:flutter_login_types/core/client/login_client.dart';

class LoginRepository {
  LoginRepository({required this.client});

  final LoginClient client;

  Future<String?> authenticate({
    required String username,
    required String password,
  }) =>
      client.authenticate(username: username, password: password);

  Future<String?> verifyPhone({required String phone}) =>
      client.verifyPhone(phoneNumber: phone);

  Future<String?> verifyCode({required String passcode}) =>
      client.verifyCode(code: passcode);

  Future<String?> authenticateGoogle() => client.authenticateGoogle();

  Future<String?> authenticateApple() => client.authenticateApple();

  Future<Map<String, dynamic>> authenticateFacebook() =>
      client.authenticateFacebook();

  Future<Map<String, dynamic>> authenticateTwitter() =>
      client.authenticateTwitter();

  Future<Map<String, dynamic>> authenticateAzure({String? language}) =>
      client.authenticateAzure(language: language);

  Future<Map<String, dynamic>> authenticateAuth0() =>
      client.authenticateAuth0();
}
