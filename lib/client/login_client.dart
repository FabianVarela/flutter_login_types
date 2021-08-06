import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginClient {
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

  Future<Map<String, dynamic>> authenticateFacebook() async {
    var accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken == null) {
      final loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        accessToken = loginResult.accessToken;
      } else {
        return <String, dynamic>{'status': loginResult.status};
      }
    }

    print(accessToken!.toJson());

    final userData = await FacebookAuth.instance.getUserData();
    print(userData);

    return userData;
  }
}
