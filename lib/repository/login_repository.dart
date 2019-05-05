import 'package:login_bloc/client/login_client.dart';

class LoginRepository {
  final client = LoginClient();

  Future<String> authenticate(String username, String password) =>
      client.authenticate(username, password);
}
