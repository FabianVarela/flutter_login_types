import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_types/core/config/app_config.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutClient {
  LogoutClient({required this.appConfig, required this.auth0});

  final AppConfig appConfig;
  final Auth0 auth0;

  Future<void> logout(LoginType loginType) async {
    switch (loginType) {
      case .simple:
        await _logoutSimple();
      case .passcode:
        await _logoutPasscode();
      case .fingerprint:
        break;
      case .google:
        await _logoutGoogle();
      case .apple:
        await _logoutApple();
      case .facebook:
        await _logoutFacebook();
      case .twitter:
        await _logoutTwitter();
      case .azure:
        await _logoutAzure();
      case .auth0:
        await _logoutAuth0();
    }
  }

  Future<void> _logoutSimple() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  Future<void> _logoutPasscode() async {
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

  Future<void> _logoutApple() async {
    // Apple Sign In doesn't require explicit logout
  }

  Future<void> _logoutFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<void> _logoutTwitter() async {
    // Twitter login doesn't have explicit logout method
  }

  Future<void> _logoutAzure() async {
    // Azure AD B2C logout is typically handled by revoking tokens
    // or clearing credentials on the client side
  }

  Future<void> _logoutAuth0() async {
    final scheme = switch (defaultTargetPlatform) {
      .android => appConfig.auth0Config.scheme,
      _ => null,
    };

    await auth0.webAuthentication(scheme: scheme).logout();
  }
}
