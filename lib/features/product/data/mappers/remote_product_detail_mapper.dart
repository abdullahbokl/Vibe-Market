import '../../domain/entities/product_entities.dart';
import 'remote_product_summary_mapper.dart';

ProductDetail? mapRemoteProductDetail(Map<String, dynamic> json) {
  final ProductSummary? summary = mapRemoteProductSummary(json);
  if (summary == null) {
    return null;
  }

  final String description =
      json['description'] as String? ?? 'Premium product detail coming soon.';
  final List<ProductMedia> gallery = _mapMediaGallery(
    summaryId: summary.id,
    fallbackImageUrl: summary.heroImageUrl,
    items: json['product_media'] as List<dynamic>? ?? const <dynamic>[],
  );
  return ProductDetail(
    summary: summary,
    description: description,
    story: buildProductStory(summary: summary, description: description),
    mediaGallery: gallery,
    highlights: buildProductHighlights(summary, description),
  );
}

List<ProductMedia> _mapMediaGallery({
  required String summaryId,
  required String fallbackImageUrl,
  required List<dynamic> items,
}) {
  final List<ProductMedia> gallery = items
      .whereType<Map<dynamic, dynamic>>()
      .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
      .map((Map<String, dynamic> media) {
        return ProductMedia(
          id: media['id'] as String? ?? '${summaryId}_media',
          url: media['media_url'] as String? ?? fallbackImageUrl,
          type: media['media_type'] as String? ?? 'image',
        );
      })
      .toList();
  if (gallery.isNotEmpty) {
    return gallery;
  }
  return <ProductMedia>[
    ProductMedia(id: '${summaryId}_hero', url: fallbackImageUrl, type: 'image'),
  ];
}

List<String> buildProductHighlights(ProductSummary summary, String description) {
  final List<String> highlights = <String>[
    summary.dropMetadata.dropLabel,
    '${summary.inventory.availableCount} units still available',
    'Seller: ${summary.seller.displayName}',
    ...summary.tags.take(2).map((String tag) => tag.replaceAll('-', ' ')),
  ];
  final String trimmedDescription = description.trim();
  if (trimmedDescription.isNotEmpty) {
    highlights.add(
      trimmedDescription.length <= 72
          ? trimmedDescription
          : '${trimmedDescription.substring(0, 69)}...',
    );
  }
  return highlights.take(5).toList();
}

String buildProductStory({
  required ProductSummary summary,
  required String description,
}) {
  final String lead = summary.dropMetadata.saleEndTime == null
      ? '${summary.title} is part of the everyday catalog.'
      : '${summary.title} arrives in ${summary.dropMetadata.dropLabel.toLowerCase()} form.';
  return '$lead ${description.trim()}';
}
