import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({
    required this.onOpenSignIn,
    required this.onOpenCheckout,
    super.key,
  });

  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenCheckout;

  @override
  Widget build(BuildContext context) {
    if (!context.watch<AuthCubit>().state.canAccessProtectedActions) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: AuthGateCard(
          title: 'Your cart belongs to your account',
          message:
              'Sign in to persist cart items across devices and complete checkout.',
          onPressed: onOpenSignIn,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (BuildContext context, CartState state) {
          if (state.snapshot.isEmpty && !state.isBusy) {
            return const EmptyStateView(
              title: 'Cart is empty',
              message:
                  'Add a live drop from the feed or search to begin checkout.',
            );
          }
          return Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final item = state.snapshot.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CartItemCard(
                              item: item,
                              isBusy: state.isBusy,
                              onUpdateQuantity: (int newQuantity) => context
                                  .read<CartCubit>()
                                  .updateQuantity(
                                    productId: item.product.id,
                                    quantity: newQuantity,
                                  ),
                            ),
                          );
                        },
                        childCount: state.snapshot.items.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CartSummary(
                        subtotalCents: state.snapshot.subtotalCents,
                        onCheckout: onOpenCheckout,
                        isBusy: state.isBusy,
                      ),
                    ),
                  ),
                ],
              ),
              if (state.isBusy)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
