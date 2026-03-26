import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'catalog_product_builder.dart';

List<ProductDetail> getMainCatalogChunk3(DateTime now) {
  return <ProductDetail>[
    CatalogProductBuilder.build(
      id: 'velvet_smoke_fragrance',
      title: 'Velvet Smoke Fragrance',
      tagline: 'Warm amber scent with suede, cedar, and dusk spice.',
      priceCents: 14200,
      heroImageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_quiet', handle: '@quietarchive', displayName: 'Quiet Archive'),
      inventory: const InventorySnapshot(availableCount: 26, totalCount: 140, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Evening Ritual'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 287, liveViewerCount: 68, hasReacted: false),
      tags: const <String>['fragrance', 'perfume', 'luxury', 'evening'],
      description: 'A limited fragrance release with soft smoke, amber resin, and skin-close woods for elegant night wear.',
      story: 'This gives the semantic layer a scent and mood category, which is useful for testing broader lifestyle language.',
      highlights: const <String>['Amber and cedar core', 'Soft suede opening', 'Collector-style bottle'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_13', url: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'tidebreaker_sailing_shell',
      title: 'Tidebreaker Sailing Shell',
      tagline: 'Salt-ready outer layer built for wind, spray, and marina nights.',
      priceCents: 23600,
      heroImageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_harbor', handle: '@harbordivision', displayName: 'Harbor Division'),
      inventory: const InventorySnapshot(availableCount: 18, totalCount: 70, isLowStock: false),
      dropMetadata: DropMetadata(saleEndTime: now.add(const Duration(hours: 14, minutes: 11)), dropLabel: 'Blue Current'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 246, liveViewerCount: 77, hasReacted: false),
      tags: const <String>['sea', 'sailing', 'jacket', 'coastal', 'outerwear'],
      description: 'A technical sea jacket with storm zip shielding, breathable lining, and a premium deck-ready silhouette.',
      story: 'Built for bright water, cold spray, and marina movement, this shell gives the catalog a true coastal performance piece.',
      highlights: const <String>['Storm-ready front placket', 'Breathable lining', 'Deck-focused mobility cut'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_14', url: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'azure_deck_sandals',
      title: 'Azure Deck Sandals',
      tagline: 'Grip-soled sandals for hot piers and bright water days.',
      priceCents: 8400,
      heroImageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_shoreline', handle: '@shorelineatelier', displayName: 'Shoreline Atelier'),
      inventory: const InventorySnapshot(availableCount: 30, totalCount: 140, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Sun Pier'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 188, liveViewerCount: 61, hasReacted: false),
      tags: const <String>['sea', 'sandals', 'beach', 'travel', 'summer'],
      description: 'Minimal premium sandals with fast-dry straps and soft foam support for sea trips and beach clubs.',
      story: 'These sandals are built for summer movement and give search a casual sea-day footwear option.',
      highlights: const <String>['Fast-dry web straps', 'Soft foam footbed', 'High-grip sole pattern'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_15', url: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'marina_weekend_tote',
      title: 'Marina Weekend Tote',
      tagline: 'Oversized carry-all for towels, sunscreen, and sea-day extras.',
      priceCents: 12800,
      heroImageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_coast', handle: '@coasttheory', displayName: 'Coast Theory'),
      inventory: const InventorySnapshot(availableCount: 24, totalCount: 90, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Harbor Carry'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 214, liveViewerCount: 66, hasReacted: false),
      tags: const <String>['sea', 'beach', 'tote', 'bag', 'weekend'],
      description: 'A structured tote with coated canvas, internal bottle holders, and a soft coastal palette for boat and beach days.',
      story: 'The marina tote brings a relaxed premium travel mood into the catalog and gives sea-related searches a carry accessory.',
      highlights: const <String>['Coated canvas shell', 'Oversized carry volume', 'Internal bottle sleeves'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_16', url: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
  ];
}
