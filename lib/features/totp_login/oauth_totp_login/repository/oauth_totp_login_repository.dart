import 'package:flutter_login_types/features/totp_login/oauth_totp_login/client/oauth_totp_login_client.dart';

class OauthTotpLoginRepository {
  OauthTotpLoginRepository({required this.client});

  final OauthTotpLoginClient client;

  Future<String?> signInWithOAuth() => client.signInWithOAuth();

  Future<String> generateToken() => client.generateToken();
}
