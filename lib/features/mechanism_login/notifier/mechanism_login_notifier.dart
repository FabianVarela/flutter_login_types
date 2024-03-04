import 'dart:async';

import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MechanismException implements Exception {
  MechanismException({required this.message});

  final String message;
}

enum MechanismType { none, azure, auth0 }

class MechanismLoginNotifier extends AutoDisposeAsyncNotifier<MechanismType> {
  @override
  FutureOr<MechanismType> build() => MechanismType.none;

  Future<void> authenticateAzure({String? lang}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final result = await repository.authenticateAzure(lang: lang);
        print(result);

        return MechanismType.azure;
      } on Exception catch (_) {
        throw MechanismException(message: MechanismType.azure.name);
      }
    });
  }

  Future<void> authenticateAuth0() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final result = await repository.authenticateAuth0();
        print(result);

        return MechanismType.auth0;
      } on Exception catch (_) {
        throw MechanismException(message: MechanismType.auth0.name);
      }
    });
  }
}

final mechanismLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<MechanismLoginNotifier, MechanismType>(
  MechanismLoginNotifier.new,
);
