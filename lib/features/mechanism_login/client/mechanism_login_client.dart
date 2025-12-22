import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';

class MechanismLoginClient {
  MechanismLoginClient({
    required this.appConfig,
    required this.appAuth,
    required this.auth0,
  });

  final AppConfig appConfig;
  final FlutterAppAuth appAuth;
  final Auth0 auth0;

  Future<Map<String, dynamic>> authenticateAzure({String? language}) async {
    try {
      final azureConfig = appConfig.azureConfig;

      final tenantId = azureConfig.tenantId;
      final policyName = azureConfig.policyName;

      final discoveryURL = Uri.https(
        '${azureConfig.tenantName}.b2clogin.com',
        '/$tenantId/$policyName/v2.0/.well-known/openid-configuration',
      );

      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          appConfig.azureConfig.clientId,
          '${azureConfig.redirectScheme}://${azureConfig.redirectPath}',
          discoveryUrl: discoveryURL.toString(),
          scopes: <String>['openid', 'profile', 'email', 'offline_access'],
          additionalParameters: <String, String>{'lang': ?language},
        ),
      );

      return <String, dynamic>{
        'idToken': result.idToken,
        'accessToken': result.accessToken,
        'refreshToken': result.refreshToken,
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> authenticateAuth0() async {
    try {
      final scheme = switch (defaultTargetPlatform) {
        .android => appConfig.auth0Config.scheme,
        _ => null,
      };

      final result = await auth0.webAuthentication(scheme: scheme).login();
      return <String, dynamic>{
        'idToken': result.idToken,
        'accessToken': result.accessToken,
        'refreshToken': result.refreshToken,
      };
    } catch (error) {
      rethrow;
    }
  }
}
