import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/cart_cubit.dart';

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
              ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  ...state.snapshot.items.map(
                    (item) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 76,
                              height: 76,
                              child: MediaPreview(
                                imageUrl: item.product.heroImageUrl,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                memCacheWidth: 152,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatPrice(
                                      priceCents: item.product.priceCents,
                                      currencyCode: item.product.currencyCode,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: state.isBusy
                                  ? null
                                  : () => context.read<CartCubit>().updateQuantity(
                                        productId: item.product.id,
                                        quantity: item.quantity - 1,
                                      ),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: state.isBusy
                                  ? null
                                  : () => context.read<CartCubit>().updateQuantity(
                                        productId: item.product.id,
                                        quantity: item.quantity + 1,
                                      ),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Subtotal: ${formatPrice(priceCents: state.snapshot.subtotalCents, currencyCode: 'USD')}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: state.isBusy ? null : onOpenCheckout,
                    child: const Text('Proceed to checkout'),
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
