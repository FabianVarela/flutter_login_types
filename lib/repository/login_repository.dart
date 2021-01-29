import 'package:login_bloc/client/login_client.dart';

class LoginRepository {
  final _client = LoginClient();

  Future<String> authenticate(String username, String password) =>
      _client.authenticate(username, password);

  Future<String> verifyPhone(String phone) => _client.verifyPhone(phone);

  Future<String> verifyCode(String code) => _client.verifyCode(code);
}
