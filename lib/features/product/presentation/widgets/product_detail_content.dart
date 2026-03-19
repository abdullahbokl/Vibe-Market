import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/product_entities.dart';
import 'product_detail_actions.dart';
import 'product_detail_gallery.dart';
import 'product_detail_highlights.dart';
import 'product_detail_summary.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({
    required this.product,
    required this.onOpenSignIn,
    required this.onOpenCheckout,
    super.key,
  });

  final ProductDetail product;
  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenCheckout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: <Widget>[
        ProductDetailGallery(mediaGallery: product.mediaGallery),
        const SizedBox(height: AppSpacing.md),
        ProductDetailSummary(
          product: product,
          onOpenSignIn: onOpenSignIn,
        ),
        const SizedBox(height: 24),
        ProductDetailActions(
          product: product.summary,
          onOpenSignIn: onOpenSignIn,
          onOpenCheckout: onOpenCheckout,
        ),
        const SizedBox(height: 16),
        ProductDetailHighlights(product: product),
      ],
    );
  }
}
