import 'package:flutter/material.dart';

import '../../domain/entities/product_entities.dart';

class ProductDetailHighlights extends StatelessWidget {
  const ProductDetailHighlights({required this.product, super.key});

  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Highlights', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...product.highlights.map((String value) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                const Icon(Icons.stars_rounded, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(value)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
