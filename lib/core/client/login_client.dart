import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class LoginClient {
  LoginClient(this._appAuth);

  final FlutterAppAuth _appAuth;

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
        clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
      );

      final credential = await googleSignIn.signIn();
      return credential?.id;
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> authenticateApple() async {
    const clientId = String.fromEnvironment('APPLE_CLIENT_ID');
    final redirectUri = Uri.parse(
      const String.fromEnvironment('APPLE_REDIRECT_URI'),
    );

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: clientId,
        redirectUri: redirectUri,
      ),
    );

    return credential.identityToken;
  }

  Future<Map<String, dynamic>> authenticateFacebook() async {
    final result = <String, dynamic>{};

    var accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken == null) {
      final loginResult = await FacebookAuth.instance.login();
      result['status'] = loginResult.status;

      if (loginResult.status == LoginStatus.success) {
        accessToken = loginResult.accessToken;
      } else {
        return result;
      }
    } else {
      result['status'] = LoginStatus.success;
    }

    return <String, dynamic>{
      ...result,
      ...await FacebookAuth.instance.getUserData(),
    };
  }

  Future<Map<String, dynamic>> authenticateTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: const String.fromEnvironment('TWITTER_API_KEY'),
      apiSecretKey: const String.fromEnvironment('TWITTER_API_SECRET'),
      redirectURI: const String.fromEnvironment('TWITTER_REDIRECT_URI'),
    );

    final authResult = await twitterLogin.login();
    return <String, dynamic>{
      'status': authResult.status,
      'token': authResult.authToken,
    };
  }

  Future<Map<String, dynamic>> authenticateAzure({String? lang}) async {
    try {
      const tenantName = String.fromEnvironment('AZURE_TENANT_NAME');
      const tenantId = String.fromEnvironment('AZURE_TENANT_ID');
      const policyName = String.fromEnvironment('AZURE_POLICY_NAME');

      const clientId = String.fromEnvironment('AZURE_CLIENT_ID');
      const redirectURL = String.fromEnvironment('AZURE_REDIRECT_URL');

      final discoveryURL = Uri.https(
        '$tenantName.b2clogin.com',
        '/$tenantId/$policyName/v2.0/.well-known/openid-configuration',
      );

      final params = lang != null ? <String, String>{'lang': lang} : null;
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectURL,
          discoveryUrl: discoveryURL.toString(),
          scopes: <String>['openid', 'profile', 'email', 'offline_access'],
          additionalParameters: params,
        ),
      );

      if (result != null) {
        return <String, dynamic>{
          'idToken': result.idToken,
          'accessToken': result.accessToken,
          'refreshToken': result.refreshToken,
        };
      }

      throw Exception('Error logging in');
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> authenticateAuth0() async {
    const auth0Domain = String.fromEnvironment('AUTH0_DOMAIN');
    const auth0ClientId = String.fromEnvironment('AUTH0_CLIENT_ID');

    final auth0 = Auth0(auth0Domain, auth0ClientId);
    final credentials = await auth0.webAuthentication().login();

    return <String, dynamic>{
      'idToken': credentials.idToken,
      'accessToken': credentials.accessToken,
      'refreshToken': credentials.refreshToken,
    };
  }
}
