import 'package:flutter_login_types/features/totp_login/simple_totp_login/client/totp_login_client.dart';

class TotpLoginRepository {
  TotpLoginRepository({required this.client});

  final TotpLoginClient client;

  Future<String?> authenticate({required bool hasVerifiedCode}) =>
      client.authenticate(hasVerifiedCode: hasVerifiedCode);
}
