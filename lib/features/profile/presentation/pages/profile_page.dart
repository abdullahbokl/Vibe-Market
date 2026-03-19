import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/config/app_environment.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/profile_account_card.dart';
import '../widgets/profile_appearance_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.onOpenSignIn,
    required this.onOpenWishlist,
    required this.onOpenOrders,
    super.key,
  });

  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenWishlist;
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthCubit>().state;
    final AppEnvironment environment = locator<AppEnvironment>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          ProfileAccountCard(
            authState: authState,
            environment: environment,
          ),
          const SizedBox(height: AppSpacing.md),
          const ProfileAppearanceSection(),
          const SizedBox(height: AppSpacing.md),
          if (!authState.canAccessProtectedActions)
            AuthGateCard(
              title: 'Complete your buyer profile',
              message:
                  'A signed-in account is required for wishlist, cart persistence, checkout, and order tracking.',
              onPressed: onOpenSignIn,
            )
          else ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            ListTile(
              title: const Text('Bookmarks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenWishlist,
            ),
            ListTile(
              title: const Text('Orders'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onOpenOrders,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ],
      ),
    );
  }
}
