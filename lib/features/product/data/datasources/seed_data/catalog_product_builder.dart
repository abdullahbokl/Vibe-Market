import 'package:vibemarket/features/product/domain/entities/product_entities.dart';

class CatalogProductBuilder {
  static ProductDetail build({
    required String id,
    required String title,
    required String tagline,
    required int priceCents,
    required String heroImageUrl,
    required SellerSummary seller,
    required InventorySnapshot inventory,
    required DropMetadata dropMetadata,
    required ReactionSnapshot reactionSnapshot,
    required List<String> tags,
    required String description,
    required String story,
    required List<String> highlights,
    required List<ProductMedia> gallery,
  }) {
    final ProductSummary summary = ProductSummary(
      id: id,
      title: title,
      tagline: tagline,
      priceCents: priceCents,
      currencyCode: 'USD',
      heroImageUrl: heroImageUrl,
      seller: seller,
      inventory: inventory,
      dropMetadata: dropMetadata,
      reactionSnapshot: reactionSnapshot,
      tags: tags,
    );
    return ProductDetail(
      summary: summary,
      description: description,
      story: story,
      mediaGallery: gallery,
      highlights: highlights,
    );
  }
}
