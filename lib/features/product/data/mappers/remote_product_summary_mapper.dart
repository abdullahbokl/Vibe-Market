import '../../domain/entities/product_entities.dart';

ProductSummary? mapRemoteProductSummary(Map<String, dynamic> json) {
  final Map<String, dynamic>? inventoryJson = extractInventory(json['inventory']);
  final String? id = json['id'] as String?;
  final String? title = json['title'] as String?;
  final String? tagline = json['tagline'] as String?;
  final int? priceCents = asNullableInt(json['price_cents']);
  final String? currencyCode = json['currency_code'] as String?;
  final String? heroImageUrl = json['hero_image_url'] as String?;
  final String? sellerDisplayName = json['seller_display_name'] as String?;
  final String? sellerHandle = json['seller_handle'] as String?;
  final String? dropLabel = json['drop_label'] as String?;
  if (<Object?>[
    id,
    title,
    tagline,
    priceCents,
    currencyCode,
    heroImageUrl,
    sellerDisplayName,
    sellerHandle,
    dropLabel,
  ].contains(null)) {
    return null;
  }

  final int availableCount = asInt(inventoryJson?['available_count']);
  final int totalCount = asInt(inventoryJson?['total_count']);
  final String safeId = id ?? '';
  final String safeTitle = title ?? '';
  final String safeTagline = tagline ?? '';
  final int safePriceCents = priceCents ?? 0;
  final String safeCurrencyCode = currencyCode ?? 'USD';
  final String safeHeroImageUrl = heroImageUrl ?? '';
  final String safeSellerDisplayName = sellerDisplayName ?? '';
  final String safeSellerHandle = sellerHandle ?? '';
  final String safeDropLabel = dropLabel ?? '';

  return ProductSummary(
    id: safeId,
    title: safeTitle,
    tagline: safeTagline,
    priceCents: safePriceCents,
    currencyCode: safeCurrencyCode,
    heroImageUrl: safeHeroImageUrl,
    seller: SellerSummary(
      id: '${safeId}_seller',
      handle: safeSellerHandle,
      displayName: safeSellerDisplayName,
    ),
    inventory: InventorySnapshot(
      availableCount: availableCount,
      totalCount: totalCount,
      isLowStock: availableCount <= 15,
    ),
      dropMetadata: DropMetadata(
      saleEndTime: parseDateTime(json['sale_end_time'] as String?),
      dropLabel: safeDropLabel,
    ),
    reactionSnapshot: ReactionSnapshot(
      reactionCount: 0,
      liveViewerCount: availableCount > 20 ? availableCount : 20,
      hasReacted: false,
    ),
    tags: List<String>.from(json['tag_list'] as List<dynamic>? ?? <dynamic>[]),
  );
}

Map<String, dynamic>? extractInventory(Object? inventory) {
  if (inventory is List<dynamic> && inventory.isNotEmpty) {
    final Object? first = inventory.first;
    if (first is Map<dynamic, dynamic>) {
      return Map<String, dynamic>.from(first);
    }
  }
  if (inventory is Map<dynamic, dynamic>) {
    return Map<String, dynamic>.from(inventory);
  }
  return null;
}

DateTime? parseDateTime(String? value) => value == null ? null : DateTime.tryParse(value);

int asInt(Object? value) => asNullableInt(value) ?? 0;

int? asNullableInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
