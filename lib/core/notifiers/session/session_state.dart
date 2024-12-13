part of 'session_notifier.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionStateAuthenticated extends SessionState {
  const SessionStateAuthenticated({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}

final class SessionStateUnauthenticated extends SessionState {
  const SessionStateUnauthenticated();
}