import 'package:flutter_login_types/features/simple_login/client/simple_login_client.dart';

class SimpleLoginRepository {
  SimpleLoginRepository({required this.client});

  final SimpleLoginClient client;

  Future<String?> authenticate({
    required String username,
    required String password,
  }) => client.authenticate(username: username, password: password);
}
