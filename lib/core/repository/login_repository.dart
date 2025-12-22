import 'package:flutter_login_types/features/mechanism_login/client/mechanism_login_client.dart';
import 'package:flutter_login_types/features/passcode_login/client/passcode_login_client.dart';
import 'package:flutter_login_types/features/simple_login/client/simple_login_client.dart';
import 'package:flutter_login_types/features/third_login/client/third_party_login_client.dart';

class LoginRepository {
  LoginRepository({
    required this.simpleLoginClient,
    required this.passcodeLoginClient,
    required this.thirdPartyLoginClient,
    required this.mechanismLoginClient,
  });

  final SimpleLoginClient simpleLoginClient;
  final PasscodeLoginClient passcodeLoginClient;
  final ThirdPartyLoginClient thirdPartyLoginClient;
  final MechanismLoginClient mechanismLoginClient;

  Future<String?> authenticate({
    required String username,
    required String password,
  }) => simpleLoginClient.authenticate(username: username, password: password);

  Future<String?> verifyPhone({required String phone}) =>
      passcodeLoginClient.verifyPhone(phoneNumber: phone);

  Future<String?> verifyCode({required String passcode}) =>
      passcodeLoginClient.verifyCode(code: passcode);

  Future<String?> authenticateGoogle() =>
      thirdPartyLoginClient.authenticateGoogle();

  Future<String?> authenticateApple() =>
      thirdPartyLoginClient.authenticateApple();

  Future<Map<String, dynamic>> authenticateFacebook() =>
      thirdPartyLoginClient.authenticateFacebook();

  Future<Map<String, dynamic>> authenticateTwitter() =>
      thirdPartyLoginClient.authenticateTwitter();

  Future<Map<String, dynamic>> authenticateAzure({String? language}) =>
      mechanismLoginClient.authenticateAzure(language: language);

  Future<Map<String, dynamic>> authenticateAuth0() =>
      mechanismLoginClient.authenticateAuth0();
}
