import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    required this.subtotalCents,
    required this.onCheckout,
    this.isBusy = false,
    super.key,
  });

  final int subtotalCents;
  final VoidCallback onCheckout;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 16),
        Text(
          'Subtotal: ${formatPrice(priceCents: subtotalCents, currencyCode: 'USD')}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: isBusy ? null : onCheckout,
          child: const Text('Proceed to checkout'),
        ),
      ],
    );
  }
}
