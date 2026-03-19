import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_environment.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/supabase_gateway.dart';
import '../../../../core/storage/app_secure_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required SupabaseGateway gateway,
    required AppSecureStorage secureStorage,
    required AppEnvironment environment,
  }) : _gateway = gateway,
       _secureStorage = secureStorage,
       _environment = environment;

  static const String _guestStorageKey = 'vibemarket_guest_id';

  final SupabaseGateway _gateway;
  final AppSecureStorage _secureStorage;
  final AppEnvironment _environment;

  @override
  Future<Either<Failure, AuthSession>> continueAsGuest() async {
    final String guestId = 'guest_${DateTime.now().microsecondsSinceEpoch}';
    await _secureStorage.write(key: _guestStorageKey, value: guestId);
    return right(AuthSession.guest(guestId));
  }

  @override
  Future<Either<Failure, AuthSession>> getCurrentSession() async {
    final SupabaseClient? client = _gateway.client;
    if (client != null && client.auth.currentUser != null) {
      final User user = client.auth.currentUser as User;
      return right(AuthSession.authenticated(_mapUser(user)));
    }

    final String? guestId = await _secureStorage.read(_guestStorageKey);
    if (guestId != null && guestId.isNotEmpty) {
      return right(AuthSession.guest(guestId));
    }

    return const Right<Failure, AuthSession>(AuthSession.unauthenticated());
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final SupabaseClient? client = _gateway.client;
    if (client == null) {
      return const Left<Failure, AuthSession>(
        Failure.configuration(
          'Supabase credentials are missing. Add environment values to enable email auth.',
        ),
      );
    }

    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final User? user = response.user;
      if (user == null) {
        return const Left<Failure, AuthSession>(
          Failure.authentication('No user was returned from Supabase auth.'),
        );
      }
      await _secureStorage.delete(_guestStorageKey);
      return right(AuthSession.authenticated(_mapUser(user)));
    } on AuthException catch (error) {
      return left(_mapAuthFailure(error));
    } catch (_) {
      return const Left<Failure, AuthSession>(
        Failure.unexpected('Email sign in failed unexpectedly.'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final SupabaseClient? client = _gateway.client;
    if (client == null) {
      return const Left<Failure, AuthSession>(
        Failure.configuration(
          'Supabase credentials are missing. Add environment values to enable account registration.',
        ),
      );
    }

    try {
      final AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
        data: <String, dynamic>{'display_name': displayName, 'name': displayName},
      );
      final User? user = response.user;
      final Session? session = response.session;
      if (user == null) {
        return const Right<Failure, AuthSession>(AuthSession.unauthenticated());
      }
      await _secureStorage.delete(_guestStorageKey);
      if (session == null) {
        return const Right<Failure, AuthSession>(AuthSession.unauthenticated());
      }
      return right(AuthSession.authenticated(_mapUser(user)));
    } on AuthException catch (error) {
      return left(_mapAuthFailure(error));
    } catch (_) {
      return const Left<Failure, AuthSession>(
        Failure.unexpected('Account registration failed unexpectedly.'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    final SupabaseClient? client = _gateway.client;
    if (client == null) {
      return const Left<Failure, AuthSession>(
        Failure.configuration(
          'Supabase credentials are missing. Add environment values to enable Google auth.',
        ),
      );
    }

    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _environment.redirectUrl,
      );
      return const Right<Failure, AuthSession>(AuthSession.unauthenticated());
    } on AuthException catch (error) {
      return left(_mapAuthFailure(error));
    } catch (_) {
      return const Left<Failure, AuthSession>(
        Failure.unexpected('Google sign in could not be started.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    final SupabaseClient? client = _gateway.client;
    try {
      if (client != null) {
        await client.auth.signOut();
      }
      await _secureStorage.delete(_guestStorageKey);
      return const Right<Failure, void>(null);
    } on AuthException catch (error) {
      return left(_mapAuthFailure(error));
    } catch (_) {
      return const Left<Failure, void>(
        Failure.unexpected('Sign out failed unexpectedly.'),
      );
    }
  }

  @override
  Stream<Either<Failure, AuthSession>> watchSession() async* {
    yield await getCurrentSession();

    final SupabaseClient? client = _gateway.client;
    if (client == null) {
      return;
    }

    yield* client.auth.onAuthStateChange.map((AuthState data) {
      final User? user = data.session?.user;
      if (user == null) {
        return const Right<Failure, AuthSession>(AuthSession.unauthenticated());
      }
      return right(AuthSession.authenticated(_mapUser(user)));
    });
  }

  AppUser _mapUser(User user) {
    final Map<String, dynamic> metadata =
        user.userMetadata ?? <String, dynamic>{};
    final String displayName =
        (metadata['display_name'] as String?) ??
        (metadata['full_name'] as String?) ??
        (metadata['name'] as String?) ??
        user.email ??
        'VibeMarket Member';
    return AppUser(
      id: user.id,
      email: user.email ?? 'unknown@vibemarket.app',
      displayName: displayName,
      avatarUrl: metadata['avatar_url'] as String?,
    );
  }

  Failure _mapAuthFailure(AuthException error) {
    final String message = error.message.trim();
    final String normalized = message.toLowerCase();

    if (normalized.contains('rate limit')) {
      return const Failure.authentication(
        'Too many email auth attempts were sent to Supabase. Wait a minute, try a different email, or use Google sign in / guest mode while the limit resets.',
      );
    }

    return Failure.authentication(message);
  }
}
