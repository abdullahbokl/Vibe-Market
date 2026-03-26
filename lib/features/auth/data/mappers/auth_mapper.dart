import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_session.dart';

class AuthMapper {
  static AppUser mapUser(User user) {
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

  static Failure mapAuthFailure(AuthException error) {
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
