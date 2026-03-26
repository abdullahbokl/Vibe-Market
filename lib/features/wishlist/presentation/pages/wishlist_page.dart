import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/wishlist_cubit.dart';
import '../widgets/wishlist_content.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    required this.onOpenProduct,
    required this.onOpenSignIn,
    super.key,
  });

  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    if (!context.watch<AuthCubit>().state.canAccessProtectedActions) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bookmarks')),
        body: AuthGateCard(
          title: 'Bookmarks are personal',
          message:
              'Sign in to keep saved drops synced to your profile and easy to revisit.',
          onPressed: onOpenSignIn,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (BuildContext context, WishlistState state) {
          if (state.ids.isEmpty) {
            return const EmptyStateView(
              title: 'No bookmarks yet',
              message:
                  'Tap the bookmark icon on any product to build your saved drop list.',
            );
          }
          return WishlistContent(
            ids: state.ids,
            onOpenProduct: onOpenProduct,
          );
        },
      ),
    );
  }
}
