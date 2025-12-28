import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class ThirdPartyLoginClient {
  ThirdPartyLoginClient({required this.appConfig});

  final AppConfig appConfig;

  Future<String?> authenticateGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: switch (defaultTargetPlatform) {
          .android => appConfig.googleConfig.clientIdAndroid,
          _ => null,
        },
        clientId: switch (defaultTargetPlatform) {
          .iOS => appConfig.googleConfig.clientIdIos,
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
        if (error.code == .canceled) return null;
      }
      rethrow;
    }
  }

  Future<String?> authenticateApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[.email, .fullName],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: appConfig.appleConfig.clientId,
        redirectUri: .parse(appConfig.appleConfig.redirectUri),
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
          if (loginResult.status == .success)
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
}
