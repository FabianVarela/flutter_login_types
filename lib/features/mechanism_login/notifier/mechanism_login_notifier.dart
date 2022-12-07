import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/features/mechanism_login/notifier/mechanism_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MechanismLoginNotifier extends StateNotifier<MechanismLoginState> {
  MechanismLoginNotifier(
    this._repository, [
    super.state = const MechanismLoginState.initial(),
  ]);

  final LoginRepository _repository;

  Future<void> authenticateAzure({String? lang}) async {
    try {
      state = const MechanismLoginState.loading();
      final result = await _repository.authenticateAzure(lang: lang);
      print(result);
      state = const MechanismLoginState.success();
    } on Exception catch (_) {
      state = const MechanismLoginState.error();
    }
  }
}
