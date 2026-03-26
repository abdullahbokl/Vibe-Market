import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/order_entities.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    required this.order,
    super.key,
  });

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.title),
      subtitle: Text(order.status.toUpperCase()),
      trailing: Text(
        formatPrice(
          priceCents: order.amountCents,
          currencyCode: order.currencyCode,
        ),
      ),
    );
  }
}
