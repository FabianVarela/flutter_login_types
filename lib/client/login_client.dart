class LoginClient {
  Future<String> authenticate(String username, String password) async {
    await Future.delayed(Duration(seconds: 3));

    if (username == 'prueba@prueba.com' && password == 'password') {
      return 'MiToken';
    } else {
      return 'Error en autenticarse';
    }
  }
}
