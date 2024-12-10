import 'package:flutter_login_types/core/client/secure_storage.dart';

class SessionRepository {
  SessionRepository({required this.secureStorage});

  final SecureStorage secureStorage;

  Future<String?> getSession() => secureStorage.getSession();

  Future<void> setSession({required String session}) =>
      secureStorage.setSession(session: session);

  Future<void> deleteSession() async {
    return secureStorage.deleteSession();
  }
}
