import '../../domain/entities/product_entities.dart';

class ProductSerializers {
  const ProductSerializers._();

  static Map<String, dynamic> summaryToMap(ProductSummary product) {
    return <String, dynamic>{
      'id': product.id,
      'title': product.title,
      'tagline': product.tagline,
      'priceCents': product.priceCents,
      'currencyCode': product.currencyCode,
      'heroImageUrl': product.heroImageUrl,
      'seller': <String, dynamic>{
        'id': product.seller.id,
        'handle': product.seller.handle,
        'displayName': product.seller.displayName,
      },
      'inventory': <String, dynamic>{
        'availableCount': product.inventory.availableCount,
        'totalCount': product.inventory.totalCount,
        'isLowStock': product.inventory.isLowStock,
      },
      'dropMetadata': <String, dynamic>{
        'saleEndTime': product.dropMetadata.saleEndTime?.toIso8601String(),
        'dropLabel': product.dropMetadata.dropLabel,
      },
      'reactionSnapshot': <String, dynamic>{
        'reactionCount': product.reactionSnapshot.reactionCount,
        'liveViewerCount': product.reactionSnapshot.liveViewerCount,
        'hasReacted': product.reactionSnapshot.hasReacted,
      },
      'tags': product.tags,
    };
  }

  static ProductSummary summaryFromMap(Map<String, dynamic> json) {
    final Map<String, dynamic> sellerJson = Map<String, dynamic>.from(
      json['seller'] as Map,
    );
    final Map<String, dynamic> inventoryJson = Map<String, dynamic>.from(
      json['inventory'] as Map,
    );
    final Map<String, dynamic> dropJson = Map<String, dynamic>.from(
      json['dropMetadata'] as Map,
    );
    final Map<String, dynamic> reactionJson = Map<String, dynamic>.from(
      json['reactionSnapshot'] as Map,
    );
    return ProductSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      priceCents: json['priceCents'] as int,
      currencyCode: json['currencyCode'] as String,
      heroImageUrl: json['heroImageUrl'] as String,
      seller: SellerSummary(
        id: sellerJson['id'] as String,
        handle: sellerJson['handle'] as String,
        displayName: sellerJson['displayName'] as String,
      ),
      inventory: InventorySnapshot(
        availableCount: inventoryJson['availableCount'] as int,
        totalCount: inventoryJson['totalCount'] as int,
        isLowStock: inventoryJson['isLowStock'] as bool,
      ),
      dropMetadata: DropMetadata(
        saleEndTime: (dropJson['saleEndTime'] as String?) == null
            ? null
            : DateTime.tryParse(dropJson['saleEndTime'] as String),
        dropLabel: dropJson['dropLabel'] as String,
      ),
      reactionSnapshot: ReactionSnapshot(
        reactionCount: reactionJson['reactionCount'] as int,
        liveViewerCount: reactionJson['liveViewerCount'] as int,
        hasReacted: reactionJson['hasReacted'] as bool,
      ),
      tags: List<String>.from(json['tags'] as List<dynamic>),
    );
  }
}
