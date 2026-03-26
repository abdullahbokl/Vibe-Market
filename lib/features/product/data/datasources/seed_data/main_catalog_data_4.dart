import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'catalog_product_builder.dart';

List<ProductDetail> getMainCatalogChunk4(DateTime now) {
  return <ProductDetail>[
    CatalogProductBuilder.build(
      id: 'reef_stripe_towel_set',
      title: 'Reef Stripe Towel Set',
      tagline: 'Heavy cotton towels with resort-weight softness.',
      priceCents: 7600,
      heroImageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_tidal', handle: '@tidalhome', displayName: 'Tidal Home'),
      inventory: const InventorySnapshot(availableCount: 36, totalCount: 180, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Cabana Stack'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 153, liveViewerCount: 49, hasReacted: false),
      tags: const <String>['sea', 'towel', 'beach', 'resort', 'summer'],
      description: 'A premium towel bundle for sea escapes, with oversized weave, absorbent loops, and clean striped detailing.',
      story: 'This set adds a resort and leisure layer to the catalog for beach and poolside semantic prompts.',
      highlights: const <String>['Resort-weight cotton', 'Oversized weave texture', 'Quick-dry absorbency'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_17', url: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'coastline_snorkel_kit',
      title: 'Coastline Snorkel Kit',
      tagline: 'Clear-view mask and low-drag fins for bright-water mornings.',
      priceCents: 15400,
      heroImageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_bluearc', handle: '@bluearc', displayName: 'Blue Arc'),
      inventory: const InventorySnapshot(availableCount: 15, totalCount: 60, isLowStock: true),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Open Water'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 198, liveViewerCount: 58, hasReacted: false),
      tags: const <String>['sea', 'snorkel', 'travel', 'water-sport', 'beach'],
      description: 'A premium snorkel starter set with anti-fog lens treatment, travel mesh bag, and sea-ready comfort fit.',
      story: 'It rounds out the sea cluster with an activity-driven product instead of another apparel item.',
      highlights: const <String>['Anti-fog clear-view mask', 'Travel mesh carry bag', 'Comfort-fit snorkel mouthpiece'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_18', url: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'ivory_vow_silk_shirt',
      title: 'Ivory Vow Silk Shirt',
      tagline: 'Soft-shine ceremony shirt cut for wedding light.',
      priceCents: 17200,
      heroImageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_maison', handle: '@maisonthread', displayName: 'Maison Thread'),
      inventory: const InventorySnapshot(availableCount: 14, totalCount: 55, isLowStock: true),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Ceremony Edit'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 266, liveViewerCount: 92, hasReacted: false),
      tags: const <String>['marriage', 'wedding', 'shirt', 'formal', 'ceremony'],
      description: 'A premium silk-blend shirt tailored for marriage celebrations, formal portraits, and clean tuxedo layering.',
      story: 'This gives wedding search a polished core formalwear piece suited to ceremony and reception styling.',
      highlights: const <String>['Silk-blend formal fabric', 'Ceremony-ready collar shape', 'Portrait-friendly sheen'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_19', url: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'midnight_ceremony_blazer',
      title: 'Midnight Ceremony Blazer',
      tagline: 'Structured formal jacket with satin-edge restraint.',
      priceCents: 31400,
      heroImageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_blackroom', handle: '@blackroomtailor', displayName: 'Blackroom Tailor'),
      inventory: const InventorySnapshot(availableCount: 11, totalCount: 40, isLowStock: true),
      dropMetadata: DropMetadata(saleEndTime: now.add(const Duration(hours: 29, minutes: 8)), dropLabel: 'Reception Night'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 322, liveViewerCount: 101, hasReacted: false),
      tags: const <String>['marriage', 'wedding', 'blazer', 'formal', 'luxury'],
      description: 'A deep navy blazer made for marriage receptions and black-tie entrances, with sharp lines and soft movement.',
      story: 'This blazer anchors formal wedding queries and adds a stronger tailoring signal to the semantic catalog.',
      highlights: const <String>['Satin-edge detailing', 'Tailored evening structure', 'Reception-ready movement'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_20', url: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
  ];
}
