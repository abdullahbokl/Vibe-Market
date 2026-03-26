import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'catalog_product_builder.dart';

List<ProductDetail> getMainCatalogChunk2(DateTime now) {
  return <ProductDetail>[
    CatalogProductBuilder.build(
      id: 'ember_court_sneakers',
      title: 'Ember Court Sneakers',
      tagline: 'Low-profile leather runner with warm copper accents.',
      priceCents: 21400,
      heroImageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_district', handle: '@districtassembly', displayName: 'District Assembly'),
      inventory: const InventorySnapshot(availableCount: 17, totalCount: 75, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Street Rotation'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 418, liveViewerCount: 132, hasReacted: false),
      tags: const <String>['sneakers', 'footwear', 'runner', 'streetwear'],
      description: 'Street-ready sneakers with premium leather panels, comfort foam, and subtle metallic accents designed for all-day rotation.',
      story: 'This pair sits between performance runner energy and premium casual styling, which makes it ideal for testing vibe-driven search prompts.',
      highlights: const <String>['Soft-touch leather upper', 'Copper accent hardware', 'Cushioned city sole'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_9', url: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'atlas_pour_over_set',
      title: 'Atlas Pour-Over Set',
      tagline: 'Stoneware brew ritual kit for slow morning drops.',
      priceCents: 9800,
      heroImageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_meridian', handle: '@housemeridian', displayName: 'House Meridian'),
      inventory: const InventorySnapshot(availableCount: 28, totalCount: 110, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Morning Ritual'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 275, liveViewerCount: 81, hasReacted: false),
      tags: const <String>['coffee', 'brew', 'pour-over', 'cafe', 'home'],
      description: 'A coffee ritual set with dripper, server, and tactile cups that makes home brewing feel like a premium drop experience.',
      story: 'The set adds a softer lifestyle angle to the catalog so search can be tested beyond apparel and accessories.',
      highlights: const <String>['Textured stoneware finish', 'Balanced pour geometry', 'Gift-ready packaging'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_10', url: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'halo_desk_lamp',
      title: 'Halo Desk Lamp',
      tagline: 'Soft ambient beam built for focused night sessions.',
      priceCents: 13200,
      heroImageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_still', handle: '@stillform', displayName: 'Still Form'),
      inventory: const InventorySnapshot(availableCount: 19, totalCount: 80, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Studio Focus'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 193, liveViewerCount: 57, hasReacted: false),
      tags: const <String>['desk', 'workspace', 'lighting', 'minimal'],
      description: 'A compact desk lamp with dimmable warmth, studio-ready glow, and a clean silhouette for focused evening work.',
      story: 'This product gives the search system a workspace and productivity cluster that should respond to mood-based prompts.',
      highlights: const <String>['Dimmable warm beam', 'Weighted metal base', 'Small-footprint design'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_11', url: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'meridian_camera_sling',
      title: 'Meridian Camera Sling',
      tagline: 'Compact creator carry with padded lens bays.',
      priceCents: 15600,
      heroImageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_frame', handle: '@framestate', displayName: 'Frame State'),
      inventory: const InventorySnapshot(availableCount: 12, totalCount: 45, isLowStock: true),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Creator Pack'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 361, liveViewerCount: 109, hasReacted: false),
      tags: const <String>['camera', 'photography', 'bag', 'creator'],
      description: 'A travel sling for mirrorless kits, batteries, and creator essentials with weather-safe structure and quick access.',
      story: 'The camera sling adds a creator-tech cluster that should surface for photography, travel, and gear-organizer searches.',
      highlights: const <String>['Padded lens dividers', 'Weather-safe shell', 'Quick side access'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_12', url: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
  ];
}
