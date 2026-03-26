import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/countdown_pill.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../../core/widgets/price_badge.dart';
import '../../../product/domain/entities/product_entities.dart';

class FeedProductCard extends StatelessWidget {
  const FeedProductCard({
    required this.product,
    required this.onOpenProduct,
    required this.onToggleWishlist,
    required this.isWishlisted,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onOpenProduct;
  final VoidCallback onToggleWishlist;
  final bool isWishlisted;

  @override
  Widget build(BuildContext context) {
    final DateTime? saleEndTime = product.dropMetadata.saleEndTime;
    final String priceLabel = formatPrice(
      priceCents: product.priceCents,
      currencyCode: product.currencyCode,
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: MediaPreview(
                      imageUrl: product.heroImageUrl,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                  ),
                  if (saleEndTime != null)
                    Positioned(
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      child: RepaintBoundary(
                        child: CountdownPill(
                          endTime: saleEndTime,
                          precision: CountdownPill.resolvePrecision(saleEndTime),
                        ),
                      ),
                    ),
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: IconButton.filledTonal(
                      onPressed: onToggleWishlist,
                      icon: Icon(
                        isWishlisted ? Icons.bookmark : Icons.bookmark_border,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.seller.displayName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(product.tagline),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      PriceBadge(
                        label: priceLabel,
                      ),
                      const Spacer(),
                      Text('${product.reactionSnapshot.liveViewerCount} live'),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton(
                        onPressed: onOpenProduct,
                        child: const Text('View'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
