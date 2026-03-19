part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.session,
    required this.isBusy,
    this.failure,
    this.statusMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      session: AuthSession.unauthenticated(),
      isBusy: false,
    );
  }

  final AuthSession session;
  final bool isBusy;
  final Failure? failure;
  final String? statusMessage;

  bool get canAccessProtectedActions => session.isAuthenticated;

  String get userScope {
    final AppUser? user = session.user;
    if (user != null) {
      return 'user-${user.id}';
    }
    return 'guest';
  }

  AuthState copyWith({
    AuthSession? session,
    bool? isBusy,
    Failure? failure,
    String? statusMessage,
  }) {
    return AuthState(
      session: session ?? this.session,
      isBusy: isBusy ?? this.isBusy,
      failure: failure,
      statusMessage: statusMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[session, isBusy, failure, statusMessage];
}
