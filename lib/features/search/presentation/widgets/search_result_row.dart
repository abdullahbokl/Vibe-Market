import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../product/domain/entities/product_entities.dart';

class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    required this.product,
    required this.onTap,
    super.key,
  });

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
