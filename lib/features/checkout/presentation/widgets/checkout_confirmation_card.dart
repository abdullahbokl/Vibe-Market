import 'package:flutter/material.dart';

import '../../domain/entities/checkout_entities.dart';

class CheckoutConfirmationCard extends StatelessWidget {
  const CheckoutConfirmationCard({
    required this.confirmation,
    required this.onOpenOrders,
    super.key,
  });

  final CheckoutConfirmation confirmation;
  final VoidCallback onOpenOrders;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
      ],
    );
  }
}
