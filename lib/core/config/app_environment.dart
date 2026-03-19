import 'package:equatable/equatable.dart';

class AppEnvironment extends Equatable {
  const AppEnvironment({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.stripePublishableKey,
    required this.deepLinkScheme,
    required this.appFlavor,
    required this.enableDemoMode,
  });

  factory AppEnvironment.fromDefines() {
    return const AppEnvironment(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      stripePublishableKey: String.fromEnvironment('STRIPE_PUBLISHABLE_KEY'),
      deepLinkScheme: String.fromEnvironment(
        'APP_DEEP_LINK_SCHEME',
        defaultValue: 'vibemarket',
      ),
      appFlavor: String.fromEnvironment(
        'APP_FLAVOR',
        defaultValue: 'development',
      ),
      enableDemoMode: bool.fromEnvironment(
        'ENABLE_DEMO_MODE',
        defaultValue: true,
      ),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String stripePublishableKey;
  final String deepLinkScheme;
  final String appFlavor;
  final bool enableDemoMode;

  bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  bool get isStripeConfigured => stripePublishableKey.isNotEmpty;

  bool get isDemoMode => enableDemoMode || !isSupabaseConfigured;

  String get redirectUrl => '$deepLinkScheme://login-callback/';

  @override
  List<Object?> get props => <Object?>[
    supabaseUrl,
    supabaseAnonKey,
    stripePublishableKey,
    deepLinkScheme,
    appFlavor,
    enableDemoMode,
  ];
}
