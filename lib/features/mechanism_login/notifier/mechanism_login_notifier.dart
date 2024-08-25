import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_login_types/core/dependencies/dependencies.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MechanismException implements Exception {
  MechanismException({required this.type, required this.error});

  final MechanismType type;
  final MechanismError error;
}

enum MechanismType { none, azure, auth0 }

enum MechanismError { error, cancelled }

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
      } on Exception catch (e) {
        var error = MechanismError.error;
        if (e is FlutterAppAuthUserCancelledException) {
          error = MechanismError.cancelled;
        }
        throw MechanismException(type: MechanismType.azure, error: error);
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
      } on Exception catch (e) {
        var error = MechanismError.error;
        if (e is WebAuthenticationException) {
          if (e.code == 'a0.authentication_canceled') {
            error = MechanismError.cancelled;
          }
        }
        throw MechanismException(type: MechanismType.auth0, error: error);
      }
    });
  }
}

final mechanismLoginNotifierProvider =
    AsyncNotifierProvider.autoDispose<MechanismLoginNotifier, MechanismType>(
  MechanismLoginNotifier.new,
);
