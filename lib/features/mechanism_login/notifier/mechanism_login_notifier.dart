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

typedef MechanismInfo = ({MechanismType type, String? token});

class MechanismLoginNotifier extends AutoDisposeAsyncNotifier<MechanismInfo> {
  @override
  FutureOr<MechanismInfo> build() => (type: MechanismType.none, token: null);

  Future<void> authenticateAzure({String? language}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(loginRepositoryProvider);
        final result = await repository.authenticateAzure(language: language);

        return (
          type: MechanismType.azure,
          token: result['accessToken'] as String,
        );
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

        return (
          type: MechanismType.auth0,
          token: result['accessToken'] as String,
        );
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
    AsyncNotifierProvider.autoDispose<MechanismLoginNotifier, MechanismInfo>(
  MechanismLoginNotifier.new,
);
