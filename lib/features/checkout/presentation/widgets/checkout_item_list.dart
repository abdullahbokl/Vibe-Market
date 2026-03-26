import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../cart/domain/entities/cart_entities.dart';

class CheckoutItemList extends StatelessWidget {
  const CheckoutItemList({
    required this.items,
    super.key,
  });

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map(
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
      ).toList(),
    );
  }
}
