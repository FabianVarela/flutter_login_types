import 'package:flutter_login_types/core/repository/login_repository.dart';
import 'package:flutter_login_types/features/simple_login/notifier/simple_login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleLoginNotifier extends StateNotifier<SimpleLoginState> {
  SimpleLoginNotifier(
    this._repository, [
    super.state = const SimpleLoginState.initial(),
  ]);

  final LoginRepository _repository;

  Future<void> authenticate(String email, String password) async {
    state = const SimpleLoginState.loading();
    final token = await _repository.authenticate(email, password);

    state = token != null && token == 'MiToken'
        ? const SimpleLoginState.success()
        : const SimpleLoginState.error();
  }
}
