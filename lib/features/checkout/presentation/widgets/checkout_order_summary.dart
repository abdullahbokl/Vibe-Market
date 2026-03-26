import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/checkout_entities.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({
    required this.quote,
    super.key,
  });

  final CheckoutQuote quote;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
    );
  }
}
