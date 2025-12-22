import 'package:uuid/uuid.dart';

class SimpleLoginClient {
  Future<String?> authenticate({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return username == 'prueba@prueba.com' && password == 'password'
        ? const Uuid().v4()
        : null;
  }
}
