import 'package:freezed_annotation/freezed_annotation.dart';

part 'mechanism_login_state.freezed.dart';

@freezed
class MechanismLoginState with _$MechanismLoginState {
  const factory MechanismLoginState.initial() = _MechanismLoginStateInitial;

  const factory MechanismLoginState.loading() = _MechanismLoginStateLoading;

  const factory MechanismLoginState.success() = _MechanismLoginStateSuccess;

  const factory MechanismLoginState.error() = _MechanismLoginStateError;
}

extension MechanismLoginStateX on MechanismLoginState {
  bool get isLoading => this is _MechanismLoginStateLoading;

  bool get isSuccess => this is _MechanismLoginStateSuccess;

  bool get isError => this is _MechanismLoginStateError;
}
