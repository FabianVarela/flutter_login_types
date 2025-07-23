import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:uuid/uuid.dart';

class LoginClient {
  LoginClient({
    required this.appConfig,
    required this.appAuth,
    required this.auth0,
  });

  final AppConfig appConfig;
  final FlutterAppAuth appAuth;
  final Auth0 auth0;

  Future<String?> authenticate({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return username == 'prueba@prueba.com' && password == 'password'
        ? const Uuid().v4()
        : null;
  }

  Future<String?> verifyPhone({required String phoneNumber}) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return phoneNumber == '3004567890' ? '' : null;
  }

  Future<String?> verifyCode({required String code}) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return code == '0000' ? const Uuid().v4() : null;
  }

  Future<String?> authenticateGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: switch (defaultTargetPlatform) {
          TargetPlatform.iOS => appConfig.googleConfig.clientIdIos,
          _ => appConfig.googleConfig.clientIdAndroid,
        },
      );

      final credential = await GoogleSignIn.instance.authenticate(
        scopeHint: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      return credential.id;
    } on Exception catch (error) {
      if (error is GoogleSignInException) {
        if (error.code == GoogleSignInExceptionCode.canceled) return null;
      }
      rethrow;
    }
  }

  Future<String?> authenticateApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: appConfig.appleConfig.clientId,
        redirectUri: Uri.parse(appConfig.appleConfig.redirectUri),
      ),
    );

    return credential.identityToken;
  }

  Future<Map<String, dynamic>> authenticateFacebook() async {
    try {
      final accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken == null) {
        final loginResult = await FacebookAuth.instance.login();
        return <String, dynamic>{
          'status': loginResult.status,
          if (loginResult.status == LoginStatus.success)
            'token': loginResult.accessToken?.tokenString,
        };
      }

      return <String, dynamic>{
        'status': LoginStatus.success,
        'token': accessToken.tokenString,
      };
    } on Exception catch (_) {
      return <String, dynamic>{'status': LoginStatus.failed};
    }
  }

  Future<Map<String, dynamic>> authenticateTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: appConfig.twitterConfig.apiKey,
      apiSecretKey: appConfig.twitterConfig.apiSecret,
      redirectURI: appConfig.twitterConfig.redirectUri,
    );

    final authResult = await twitterLogin.login();
    return <String, dynamic>{
      'status': authResult.status,
      'token': authResult.authToken,
    };
  }

  Future<Map<String, dynamic>> authenticateAzure({String? language}) async {
    try {
      final tenantId = appConfig.azureConfig.tenantId;
      final policyName = appConfig.azureConfig.policyName;

      final discoveryURL = Uri.https(
        '${appConfig.azureConfig.tenantName}.b2clogin.com',
        '/$tenantId/$policyName/v2.0/.well-known/openid-configuration',
      );

      final redirectFullPath =
          '${appConfig.azureConfig.redirectScheme}://'
          '${appConfig.azureConfig.redirectPath}';

      final result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          appConfig.azureConfig.clientId,
          redirectFullPath,
          discoveryUrl: discoveryURL.toString(),
          scopes: <String>['openid', 'profile', 'email', 'offline_access'],
          additionalParameters: <String, String>{
            if (language != null) 'lang': language,
          },
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
        TargetPlatform.android => appConfig.auth0Config.scheme,
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
