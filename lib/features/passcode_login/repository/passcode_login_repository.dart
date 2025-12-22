import 'package:flutter_login_types/features/passcode_login/client/passcode_login_client.dart';

class PasscodeLoginRepository {
  PasscodeLoginRepository({required this.client});

  final PasscodeLoginClient client;

  Future<String?> verifyPhone({required String phone}) =>
      client.verifyPhone(phoneNumber: phone);

  Future<String?> verifyCode({required String passcode}) =>
      client.verifyCode(code: passcode);
}
