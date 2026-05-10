import 'package:uuid/uuid.dart';

class TotpLoginClient {
  Future<String?> authenticate({required bool hasVerifiedCode}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return hasVerifiedCode ? const Uuid().v4() : null;
  }
}
