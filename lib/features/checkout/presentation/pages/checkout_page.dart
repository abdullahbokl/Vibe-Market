import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../bloc/checkout_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    required this.onOpenSignIn,
    required this.onOpenOrders,
    super.key,
  });

  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final cartState = context.watch<CartCubit>().state;

    if (!authState.canAccessProtectedActions) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: AuthGateCard(
          title: 'Checkout requires an account',
          message:
              'Secure payment, order tracking, and post-purchase notifications all depend on an authenticated session.',
          onPressed: onOpenSignIn,
        ),
      );
    }

    if (cartState.snapshot.isEmpty) {
      return const Scaffold(
        body: EmptyStateView(
          title: 'Nothing to check out',
          message: 'Add a product to cart or use Buy now from a product page.',
        ),
      );
    }

    return BlocProvider<CheckoutBloc>(
      create: (_) =>
          locator<CheckoutBloc>()..add(CheckoutStarted(cartState.snapshot)),
      child: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (BuildContext context, CheckoutState state) {
          if (state.status == CheckoutStatus.success) {
            context.read<CartCubit>().clearCart();
          }
        },
        builder: (BuildContext context, CheckoutState state) {
          final quote = state.quote;
          final failure = state.failure;
          final confirmation = state.confirmation;
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                ...cartState.snapshot.items.map(
                  (item) => ListTile(
                    title: Text(item.product.title),
                    subtitle: Text('Qty ${item.quantity}'),
                    trailing: Text(
                      formatPrice(
                        priceCents: item.lineTotalCents,
                        currencyCode: item.product.currencyCode,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 32),
                if (quote != null) ...<Widget>[
                  ListTile(
                    title: const Text('Subtotal'),
                    trailing: Text(
                      formatPrice(
                        priceCents: quote.subtotalCents,
                        currencyCode: quote.currencyCode,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Shipping'),
                    trailing: Text(
                      formatPrice(
                        priceCents: quote.shippingCents,
                        currencyCode: quote.currencyCode,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Total'),
                    trailing: Text(
                      formatPrice(
                        priceCents: quote.totalCents,
                        currencyCode: quote.currencyCode,
                      ),
                    ),
                  ),
                ],
                if (failure != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    failure.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (state.status == CheckoutStatus.success &&
                    confirmation != null) ...<Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Order confirmed',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text('Order ID: ${confirmation.orderId}'),
                          Text(
                            'Idempotency key: ${confirmation.idempotencyKey}',
                          ),
                          Text(
                            confirmation.isDemo
                                ? 'Processed in demo mode because live Stripe/Supabase credentials are not configured.'
                                : 'Processed through backend checkout orchestration.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onOpenOrders,
                    child: const Text('View orders'),
                  ),
                ] else ...<Widget>[
                  ElevatedButton(
                    onPressed: state.status == CheckoutStatus.submitting
                        ? null
                        : () {
                            context.read<CheckoutBloc>().add(
                              CheckoutSubmitted(
                                cart: cartState.snapshot,
                                session: authState.session,
                              ),
                            );
                          },
                    child: Text(
                      state.status == CheckoutStatus.submitting
                          ? 'Processing...'
                          : 'Place order',
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
