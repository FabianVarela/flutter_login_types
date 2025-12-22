import 'package:flutter_login_types/features/third_login/client/third_party_login_client.dart';

class ThirdPartyLoginRepository {
  ThirdPartyLoginRepository({required this.client});

  final ThirdPartyLoginClient client;

  Future<String?> authenticateGoogle() => client.authenticateGoogle();

  Future<String?> authenticateApple() => client.authenticateApple();

  Future<Map<String, dynamic>> authenticateFacebook() =>
      client.authenticateFacebook();

  Future<Map<String, dynamic>> authenticateTwitter() =>
      client.authenticateTwitter();
}
