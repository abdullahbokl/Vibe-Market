import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../product/domain/entities/product_entities.dart';

class WishlistItemCard extends StatelessWidget {
  const WishlistItemCard({
    required this.product,
    required this.onOpenProduct,
    required this.onRemove,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onOpenProduct;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onOpenProduct,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 92,
                height: 120,
                child: MediaPreview(
                  imageUrl: product.heroImageUrl,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  memCacheWidth: 184,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.seller.displayName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.tagline,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatPrice(
                        priceCents: product.priceCents,
                        currencyCode: product.currencyCode,
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.inventory.availableCount} left • ${product.dropMetadata.dropLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onOpenProduct,
                            child: const Text('View'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.bookmark),
                          tooltip: 'Remove bookmark',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
