import 'package:uuid/uuid.dart';

class PasscodeLoginClient {
  Future<String?> verifyPhone({required String phoneNumber}) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return phoneNumber == '3004567890' ? '' : null;
  }

  Future<String?> verifyCode({required String code}) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return code == '0000' ? const Uuid().v4() : null;
  }
}
