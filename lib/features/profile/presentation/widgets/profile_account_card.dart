import 'package:flutter/material.dart';

import '../../../../core/config/app_environment.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({
    required this.authState,
    required this.environment,
    super.key,
  });

  final AuthState authState;
  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(_subtitle),
            const SizedBox(height: AppSpacing.xs),
            Text(_environmentLabel),
          ],
        ),
      ),
    );
  }

  String get _title {
    return authState.session.isAuthenticated
        ? authState.session.user?.displayName ?? 'Member'
        : 'Guest browser';
  }

  String get _subtitle {
    return authState.session.isAuthenticated
        ? authState.session.user?.email ?? ''
        : 'Sign in to unlock saved drops, cart, and order history.';
  }

  String get _environmentLabel {
    return environment.isDemoMode
        ? 'Running in demo mode with local discovery fallbacks.'
        : 'Connected to live Supabase and Stripe services.';
  }
}
