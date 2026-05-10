import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class OauthTotpLoginClient {
  OauthTotpLoginClient({
    required this.appConfig,
    required this.appAuth,
    required this.flutterSecureStorage,
  });

  final AppConfig appConfig;
  final FlutterAppAuth appAuth;
  final FlutterSecureStorage flutterSecureStorage;

  Future<String?> signInWithOAuth({String? language}) async {
    try {
      final config = appConfig.msalConfig;
      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          config.clientId,
          '${config.redirectScheme}://auth/',
          issuer: 'https://login.microsoftonline.com/${config.tenantId}/v2.0',
          scopes: <String>['openid', 'profile', 'email', 'offline_access'],
          promptValues: ['select_account'],
          additionalParameters: <String, String>{'lang': ?language},
        ),
      );

      return result.idToken ?? result.accessToken;
    } on FlutterAppAuthUserCancelledException {
      return null;
    } catch (e, _) {
      rethrow;
    }
  }

  Future<String> generateToken() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const Uuid().v4();
  }
}
