import 'package:flutter_login_types/core/client/logout_client.dart';
import 'package:flutter_login_types/core/enum/login_type.dart';

class LogoutRepository {
  LogoutRepository({required this.client});

  final LogoutClient client;

  Future<void> logout(LoginType loginType) => client.logout(loginType);
}
