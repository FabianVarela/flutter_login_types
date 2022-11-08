import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_login_state.freezed.dart';

@freezed
class SimpleLoginState with _$SimpleLoginState {
  const factory SimpleLoginState.initial() = _SimpleLoginStateIntial;

  const factory SimpleLoginState.loading() = _SimpleLoginStateLoading;

  const factory SimpleLoginState.success() = _SimpleLoginStateSuccess;

  const factory SimpleLoginState.error() = _SimpleLoginStateError;
}

extension SimpleLoginStateX on SimpleLoginState {
  bool get isLoading => this is _SimpleLoginStateLoading;

  bool get isSuccess => this is _SimpleLoginStateSuccess;

  bool get isError => this is _SimpleLoginStateError;
}
