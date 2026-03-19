import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_environment.dart';
import '../error/failure.dart';

class SupabaseGateway {
  const SupabaseGateway({
    required this.client,
    required this.isConfigured,
    this.failure,
  });

  static Future<SupabaseGateway> initialize(AppEnvironment environment) async {
    if (!environment.isSupabaseConfigured) {
      return const SupabaseGateway(client: null, isConfigured: false);
    }

    try {
      await Supabase.initialize(
        url: environment.supabaseUrl,
        anonKey: environment.supabaseAnonKey,
      );
      return SupabaseGateway(
        client: Supabase.instance.client,
        isConfigured: true,
      );
    } catch (_) {
      return const SupabaseGateway(
        client: null,
        isConfigured: false,
        failure: Failure.configuration(
          'Supabase could not be initialized with the provided environment.',
        ),
      );
    }
  }

  final SupabaseClient? client;
  final bool isConfigured;
  final Failure? failure;
}
