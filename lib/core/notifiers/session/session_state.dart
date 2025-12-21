part of 'session_notifier.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionStateInitial extends SessionState {
  const SessionStateInitial();
}

final class SessionStateLoading extends SessionState {
  const SessionStateLoading();
}

final class SessionStateAuthenticated extends SessionState {
  const SessionStateAuthenticated({
    required this.token,
    required this.loginType,
  });

  final String token;
  final String loginType;

  @override
  List<Object?> get props => [token, loginType];
}

final class SessionStateUnauthenticated extends SessionState {
  const SessionStateUnauthenticated();
}
