import 'package:freezed_annotation/freezed_annotation.dart';

part 'passcode_login_state.freezed.dart';

enum PasscodeLoginPhase { phone, passcode }

@freezed
class PasscodeLoginState with _$PasscodeLoginState {
  const factory PasscodeLoginState.initial() = _PasscodeLoginStateInitial;

  const factory PasscodeLoginState.loading() = _PasscodeLoginStateLoading;

  const factory PasscodeLoginState.success({
    required PasscodeLoginPhase phase,
  }) = _PasscodeLoginStateSuccess;

  const factory PasscodeLoginState.error({
    required PasscodeLoginPhase phase,
  }) = _PasscodeLoginStateError;
}

extension PasscodeLoginStateX on PasscodeLoginState {
  bool get isLoading => this is _PasscodeLoginStateLoading;

  bool get isSuccess => this is _PasscodeLoginStateSuccess;

  PasscodeLoginPhase get phaseSuccess =>
      (this as _PasscodeLoginStateSuccess).phase;

  bool get isError => this is _PasscodeLoginStateError;

  PasscodeLoginPhase get phaseError => (this as _PasscodeLoginStateError).phase;
}
