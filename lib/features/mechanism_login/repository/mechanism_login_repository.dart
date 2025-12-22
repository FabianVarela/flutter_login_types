import 'package:flutter_login_types/features/mechanism_login/client/mechanism_login_client.dart';

class MechanismLoginRepository {
  MechanismLoginRepository({required this.client});

  final MechanismLoginClient client;

  Future<Map<String, dynamic>> authenticateAzure({String? language}) =>
      client.authenticateAzure(language: language);

  Future<Map<String, dynamic>> authenticateAuth0() =>
      client.authenticateAuth0();
}
