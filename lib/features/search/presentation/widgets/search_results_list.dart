import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../product/domain/entities/product_entities.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    required this.products,
    required this.isPaginating,
    required this.scrollController,
    required this.onOpenProduct,
    super.key,
  });

  final List<ProductSummary> products;
  final bool isPaginating;
  final ScrollController scrollController;
  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: products.length + (isPaginating ? 1 : 0),
      separatorBuilder: (_, ignoredIndex) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        if (index >= products.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return RepaintBoundary(
          child: _SearchResultRow(
            product: products[index],
            onTap: () => onOpenProduct(products[index].id),
          ),
        );
      },
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({required this.product, required this.onTap});

  final ProductSummary product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 72,
              height: 72,
              child: MediaPreview(
                imageUrl: product.heroImageUrl,
                borderRadius: BorderRadius.circular(AppRadius.md),
                memCacheWidth: 144,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.tagline,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
