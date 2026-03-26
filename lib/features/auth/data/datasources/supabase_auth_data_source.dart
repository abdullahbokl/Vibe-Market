import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_environment.dart';
import '../../../../core/services/supabase_gateway.dart';

class SupabaseAuthDataSource {
  SupabaseAuthDataSource({
    required SupabaseGateway gateway,
    required AppEnvironment environment,
  }) : _gateway = gateway,
       _environment = environment;

  final SupabaseGateway _gateway;
  final AppEnvironment _environment;

  SupabaseClient get _client {
    final client = _gateway.client;
    if (client == null) {
      throw const AuthException(
        'Supabase credentials are missing. Add environment values to enable auth.',
      );
    }
    return client;
  }

  User? get currentUser => _gateway.client?.auth.currentUser;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: <String, dynamic>{'display_name': displayName, 'name': displayName},
    );
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _environment.redirectUrl,
    );
  }

  Future<void> signOut() async {
    return _gateway.client?.auth.signOut();
  }

  Stream<AuthState> get onAuthStateChange {
    final client = _gateway.client;
    if (client == null) return const Stream.empty();
    return client.auth.onAuthStateChange;
  }
}
