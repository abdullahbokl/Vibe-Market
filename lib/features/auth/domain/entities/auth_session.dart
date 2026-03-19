import 'package:equatable/equatable.dart';

enum AuthStatus { unauthenticated, guest, authenticated }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;

  @override
  List<Object?> get props => <Object?>[id, email, displayName, avatarUrl];
}

class AuthSession extends Equatable {
  const AuthSession({required this.status, this.user, this.guestId});

  const AuthSession.unauthenticated()
    : this(status: AuthStatus.unauthenticated);

  const AuthSession.guest(String guestId)
    : this(status: AuthStatus.guest, guestId: guestId);

  const AuthSession.authenticated(AppUser user)
    : this(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AppUser? user;
  final String? guestId;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.guest;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  @override
  List<Object?> get props => <Object?>[status, user, guestId];
}
