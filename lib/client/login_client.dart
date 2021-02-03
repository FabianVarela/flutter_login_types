import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginClient {
  Future<String> authenticate(String username, String password) async {
    await Future.delayed(Duration(seconds: 3));

    if (username == 'prueba@prueba.com' && password == 'password') {
      return 'MiToken';
    } else {
      return 'Error en autenticarse';
    }
  }

  Future<String> verifyPhone(String phoneNumber) async {
    await Future.delayed(Duration(seconds: 3));

    if (phoneNumber == '3004567890') {
      return '';
    } else {
      return 'Error en verificar';
    }
  }

  Future<String> verifyCode(String code) async {
    await Future.delayed(Duration(seconds: 3));

    if (code == '0000') {
      return 'MiToken';
    } else {
      return 'Error en autenticarse';
    }
  }

  Future<Map<String, dynamic>> authenticateFacebook() async {
    var accessToken = await FacebookAuth.instance.isLogged;
    if (accessToken == null) {
      accessToken = await FacebookAuth.instance.login();
      print(accessToken.toJson());
    }

    final userData = await FacebookAuth.instance.getUserData();
    print(userData);

    return userData;
  }
}
