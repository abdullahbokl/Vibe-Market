import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/checkout_confirmation_card.dart';
import '../widgets/checkout_item_list.dart';
import '../widgets/checkout_order_summary.dart';

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
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                CheckoutItemList(items: cartState.snapshot.items),
                const Divider(height: 32),
                if (state.quote != null)
                  CheckoutOrderSummary(quote: state.quote!),
                if (state.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.failure!.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                const SizedBox(height: 24),
                if (state.status == CheckoutStatus.success &&
                    state.confirmation != null)
                  CheckoutConfirmationCard(
                    confirmation: state.confirmation!,
                    onOpenOrders: onOpenOrders,
                  )
                else
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
            ),
          );
        },
      ),
    );
  }
}
