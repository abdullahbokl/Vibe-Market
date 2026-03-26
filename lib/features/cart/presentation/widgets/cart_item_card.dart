import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../domain/entities/cart_entities.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.onUpdateQuantity,
    this.isBusy = false,
    super.key,
  });

  final CartItem item;
  final void Function(int newQuantity) onUpdateQuantity;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              onPressed: isBusy ? null : () => onUpdateQuantity(item.quantity - 1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${item.quantity}'),
            IconButton(
              onPressed: isBusy ? null : () => onUpdateQuantity(item.quantity + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
