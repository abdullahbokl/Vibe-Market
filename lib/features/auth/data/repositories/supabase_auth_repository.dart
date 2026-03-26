import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_secure_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_data_source.dart';
import '../mappers/auth_mapper.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required SupabaseAuthDataSource dataSource,
    required AppSecureStorage secureStorage,
  }) : _dataSource = dataSource, _secureStorage = secureStorage;

  static const String _gKey = 'vibemarket_guest_id';
  final SupabaseAuthDataSource _dataSource;
  final AppSecureStorage _secureStorage;

  @override
  Future<Either<Failure, AuthSession>> continueAsGuest() async {
    final id = 'guest_${DateTime.now().microsecondsSinceEpoch}';
    await _secureStorage.write(key: _gKey, value: id);
    return right(AuthSession.guest(id));
  }

  @override
  Future<Either<Failure, AuthSession>> getCurrentSession() async {
    final user = _dataSource.currentUser;
    if (user != null) return right(AuthSession.authenticated(AuthMapper.mapUser(user)));
    final gid = await _secureStorage.read(_gKey);
    return right(gid != null && gid.isNotEmpty ? AuthSession.guest(gid) : const AuthSession.unauthenticated());
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithEmail({required String email, required String password}) async {
    try {
      final res = await _dataSource.signInWithEmail(email: email, password: password);
      final user = res.user;
      if (user == null) return left(const Failure.authentication('No user returned.'));
      await _secureStorage.delete(_gKey);
      return right(AuthSession.authenticated(AuthMapper.mapUser(user)));
    } on AuthException catch (e) {
      return left(AuthMapper.mapAuthFailure(e));
    } catch (_) {
      return left(const Failure.unexpected('Sign in failed.'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signUpWithEmail({
    required String email, required String password, required String displayName,
  }) async {
    try {
      final res = await _dataSource.signUpWithEmail(email: email, password: password, displayName: displayName);
      final user = res.user;
      if (user == null || res.session == null) return right(const AuthSession.unauthenticated());
      await _secureStorage.delete(_gKey);
      return right(AuthSession.authenticated(AuthMapper.mapUser(user)));
    } on AuthException catch (e) {
      return left(AuthMapper.mapAuthFailure(e));
    } catch (_) {
      return left(const Failure.unexpected('Sign up failed.'));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    try {
      await _dataSource.signInWithGoogle();
      return right(const AuthSession.unauthenticated());
    } on AuthException catch (e) {
      return left(AuthMapper.mapAuthFailure(e));
    } catch (_) {
      return left(const Failure.unexpected('Google login failed.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      await _secureStorage.delete(_gKey);
      return right(null);
    } on AuthException catch (e) {
      return left(AuthMapper.mapAuthFailure(e));
    } catch (_) {
      return left(const Failure.unexpected('Sign out failed.'));
    }
  }

  @override
  Stream<Either<Failure, AuthSession>> watchSession() async* {
    yield await getCurrentSession();
    yield* _dataSource.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return right(user == null ? const AuthSession.unauthenticated() : AuthSession.authenticated(AuthMapper.mapUser(user)));
    });
  }
}
