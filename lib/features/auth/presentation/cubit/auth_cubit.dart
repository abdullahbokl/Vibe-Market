import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthState.initial()) {
    _sessionSubscription = _repository.watchSession().listen(_onSessionChanged);
  }

  final AuthRepository _repository;
  StreamSubscription? _sessionSubscription;

  Future<void> hydrateSession() => _runSessionTask(_repository.getCurrentSession);
  Future<void> continueAsGuest() => _runSessionTask(_repository.continueAsGuest);

  Future<void> signInWithEmail({required String email, required String password}) {
    return _runSessionTask(() => _repository.signInWithEmail(email: email, password: password));
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final failure = _validateSignUp(displayName: displayName, password: password);
    if (failure != null) return emit(state.copyWith(failure: failure, statusMessage: null));

    _emitBusy();
    final result = await _repository.signUpWithEmail(email: email, password: password, displayName: displayName.trim());
    result.fold(_emitFailure, (session) => _emitResolved(
          session: session,
          statusMessage: session.isAuthenticated ? 'Your account is ready.' : 'Check your email for confirmation.',
        ));
  }

  Future<void> signInWithGoogle() async {
    _emitBusy();
    final result = await _repository.signInWithGoogle();
    result.fold(_emitFailure, (_) => emit(state.copyWith(isBusy: false, failure: null, statusMessage: null)));
  }

  Future<void> signOut() async {
    _emitBusy();
    final result = await _repository.signOut();
    result.fold(_emitFailure, (_) => _emitResolved(session: const AuthSession.unauthenticated(), statusMessage: null));
  }

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    return super.close();
  }

  void _onSessionChanged(Either<Failure, AuthSession> result) {
    result.fold((f) => emit(state.copyWith(failure: f)), (s) => _emitResolved(session: s, statusMessage: null));
  }

  Future<void> _runSessionTask(Future<Either<Failure, AuthSession>> Function() action) async {
    _emitBusy();
    final result = await action();
    result.fold(_emitFailure, (session) => _emitResolved(session: session, statusMessage: null));
  }

  Failure? _validateSignUp({required String displayName, required String password}) {
    if (displayName.trim().isEmpty) return const Failure.validation('Enter a display name.');
    if (password.length < 8) return const Failure.validation('Use at least 8 characters.');
    return null;
  }

  void _emitBusy() => emit(state.copyWith(isBusy: true, failure: null, statusMessage: null));
  void _emitFailure(Failure f) => emit(state.copyWith(isBusy: false, failure: f, statusMessage: null));
  void _emitResolved({required AuthSession session, required String? statusMessage}) {
    emit(state.copyWith(isBusy: false, session: session, failure: null, statusMessage: statusMessage));
  }
}
