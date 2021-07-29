import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginClient {
  Future<String?> authenticate(String username, String password) async {
    await Future.delayed(const Duration(seconds: 3));

    return username == 'prueba@prueba.com' && password == 'password'
        ? 'MiToken'
        : null;
  }

  Future<String?> verifyPhone(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 3));
    return phoneNumber == '3004567890' ? '' : null;
  }

  Future<String?> verifyCode(String code) async {
    await Future.delayed(const Duration(seconds: 3));
    return code == '0000' ? 'MiToken' : null;
  }

  Future<Map<String, dynamic>> authenticateFacebook() async {
    var accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken == null) {
      accessToken = await FacebookAuth.instance.login();
      print(accessToken!.toJson());
    }

    final userData = await FacebookAuth.instance.getUserData();
    print(userData);

    return userData;
  }
}
