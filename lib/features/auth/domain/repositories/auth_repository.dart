import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> getCurrentSession();

  Future<Either<Failure, AuthSession>> continueAsGuest();

  Future<Either<Failure, AuthSession>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSession>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, AuthSession>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Stream<Either<Failure, AuthSession>> watchSession();
}
