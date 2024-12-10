import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage({required this.flutterSecureStorage});

  final FlutterSecureStorage flutterSecureStorage;

  static const _sessionKey = 'userSession';

  Future<String?> getSession() async {
    return flutterSecureStorage.read(key: _sessionKey);
  }

  Future<void> setSession({required String session}) async {
    return flutterSecureStorage.write(key: _sessionKey, value: session);
  }

  Future<void> deleteSession() async {
    return flutterSecureStorage.delete(key: _sessionKey);
  }
}
