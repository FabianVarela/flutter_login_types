import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginClient {
  LoginClient(this._appConfig, this._appAuth, this._auth0);

  final AppConfig _appConfig;
  final FlutterAppAuth _appAuth;
  final Auth0 _auth0;

  Future<String?> authenticate(String username, String password) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return username == 'prueba@prueba.com' && password == 'password'
        ? 'MiToken'
        : null;
  }

  Future<String?> verifyPhone(String phoneNumber) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return phoneNumber == '3004567890' ? '' : null;
  }

  Future<String?> verifyCode(String code) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return code == '0000' ? 'MiToken' : null;
  }

  Future<String?> authenticateGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
        clientId: switch (defaultTargetPlatform) {
          TargetPlatform.iOS => _appConfig.googleConfig.clientIdIos,
          _ => _appConfig.googleConfig.clientIdAndroid,
        },
      );

      final credential = await googleSignIn.signIn();
      return credential?.id;
    } catch (error) {
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
        clientId: _appConfig.appleConfig.clientId,
        redirectUri: Uri.parse(_appConfig.appleConfig.redirectUri),
      ),
    );

    return credential.identityToken;
  }

  Future<Map<String, dynamic>> authenticateFacebook() async {
    try {
      final result = <String, dynamic>{};

      final accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken == null) {
        final loginResult = await FacebookAuth.instance.login();
        result['status'] = loginResult.status;

        if (loginResult.status != LoginStatus.success) return result;
      } else {
        result['status'] = LoginStatus.success;
      }

      return <String, dynamic>{
        ...result,
        ...await FacebookAuth.instance.getUserData(),
      };
    } catch (error) {
      return <String, dynamic>{'status': LoginStatus.failed};
    }
  }

  Future<Map<String, dynamic>> authenticateTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: _appConfig.twitterConfig.apiKey,
      apiSecretKey: _appConfig.twitterConfig.apiSecret,
      redirectURI: _appConfig.twitterConfig.redirectUri,
    );

    final authResult = await twitterLogin.login();
    return <String, dynamic>{
      'status': authResult.status,
      'token': authResult.authToken,
    };
  }

  Future<Map<String, dynamic>> authenticateAzure({String? lang}) async {
    try {
      final tenantId = _appConfig.azureConfig.tenantId;
      final policyName = _appConfig.azureConfig.policyName;

      final discoveryURL = Uri.https(
        '${_appConfig.azureConfig.tenantName}.b2clogin.com',
        '/$tenantId/$policyName/v2.0/.well-known/openid-configuration',
      );

      final redirectFullPath = '${_appConfig.azureConfig.redirectScheme}://'
          '${_appConfig.azureConfig.redirectPath}';

      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _appConfig.azureConfig.clientId,
          redirectFullPath,
          discoveryUrl: discoveryURL.toString(),
          scopes: <String>['openid', 'profile', 'email', 'offline_access'],
          additionalParameters: <String, String>{
            if (lang != null) 'lang': lang,
          },
        ),
      );

      if (result == null) throw Exception('Error logging in');
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
        TargetPlatform.android => _appConfig.auth0Config.scheme,
        _ => null,
      };

      final result = await _auth0.webAuthentication(scheme: scheme).login();
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
