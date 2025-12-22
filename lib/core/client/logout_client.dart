import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutClient {
  LogoutClient({
    required this.appConfig,
    required this.auth0,
    required this.appAuth,
  });

  final AppConfig appConfig;
  final Auth0 auth0;
  final FlutterAppAuth appAuth;

  Future<void> logout({required LoginType loginType, String? idToken}) async {
    return switch (loginType) {
      .simple || .passcode || .fingerprint || .apple || .twitter => _logout(),
      .google => _logoutGoogle(),
      .facebook => _logoutFacebook(),
      .azure => _logoutAzure(idToken: idToken),
      .auth0 => _logoutAuth0(),
    };
  }

  Future<void> _logout() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<void> _logoutGoogle() async {
    await GoogleSignIn.instance.initialize(
      clientId: switch (defaultTargetPlatform) {
        .iOS => appConfig.googleConfig.clientIdIos,
        _ => appConfig.googleConfig.clientIdAndroid,
      },
    );
    await GoogleSignIn.instance.signOut();
  }

  Future<void> _logoutFacebook() => FacebookAuth.instance.logOut();

  Future<void> _logoutAzure({String? idToken}) async {
    try {
      final config = appConfig.azureConfig;

      final redirectUrl = '${config.redirectScheme}://${config.redirectPath}';
      final policy = config.policyName;
      final endpointPath = config.endpointPath;

      final request = EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: redirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: '$endpointPath/$policy/oauth2/v2.0/authorize',
          tokenEndpoint: '$endpointPath/$policy/oauth2/v2.0/token',
          endSessionEndpoint: '$endpointPath/$policy/oauth2/v2.0/logout',
        ),
      );
      await appAuth.endSession(request);
    } on Exception catch (_) {
      return;
    }
  }

  Future<void> _logoutAuth0() async {
    final scheme = switch (defaultTargetPlatform) {
      .android => appConfig.auth0Config.scheme,
      _ => null,
    };
    await auth0.webAuthentication(scheme: scheme).logout();
  }
}
