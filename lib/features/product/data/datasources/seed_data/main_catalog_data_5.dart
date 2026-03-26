import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'catalog_product_builder.dart';

List<ProductDetail> getMainCatalogChunk5(DateTime now) {
  return <ProductDetail>[
    CatalogProductBuilder.build(
      id: 'champagne_veil_dress',
      title: 'Champagne Veil Dress',
      tagline: 'Fluid satin dress designed for elegant wedding movement.',
      priceCents: 28600,
      heroImageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_velour', handle: '@velourhall', displayName: 'Velour Hall'),
      inventory: const InventorySnapshot(availableCount: 9, totalCount: 32, isLowStock: true),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Golden Aisle'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 341, liveViewerCount: 118, hasReacted: false),
      tags: const <String>['marriage', 'wedding', 'dress', 'formal', 'occasion'],
      description: 'A refined occasion dress for marriage celebrations with soft drape, luminous fabric, and quiet statement energy.',
      story: 'It brings a more expressive weddingwear silhouette into the catalog for feminine formal and guest-ceremony searches.',
      highlights: const <String>['Fluid satin drape', 'Elegant ceremony silhouette', 'Soft evening sheen'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_21', url: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'pearl_evening_heels',
      title: 'Pearl Evening Heels',
      tagline: 'Satin heels with ceremony-friendly comfort and glow.',
      priceCents: 19800,
      heroImageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_lune', handle: '@luneatelier', displayName: 'Lune Atelier'),
      inventory: const InventorySnapshot(availableCount: 13, totalCount: 48, isLowStock: true),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Reception Steps'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 224, liveViewerCount: 83, hasReacted: false),
      tags: const <String>['marriage', 'wedding', 'heels', 'formal', 'shoes'],
      description: 'Elegant formal heels designed for wedding looks, long receptions, and premium evening styling.',
      story: 'These heels extend wedding-related search beyond garments and into formal accessories with occasion intent.',
      highlights: const <String>['Satin evening finish', 'Comfort-tuned heel pitch', 'Ceremony-ready profile'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_22', url: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'tailored_vow_trousers',
      title: 'Tailored Vow Trousers',
      tagline: 'Clean formal drape for marriage weekends and late receptions.',
      priceCents: 16400,
      heroImageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_chapel', handle: '@northchapel', displayName: 'North Chapel'),
      inventory: const InventorySnapshot(availableCount: 16, totalCount: 64, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Formal Line'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 191, liveViewerCount: 63, hasReacted: false),
      tags: const <String>['marriage', 'wedding', 'trousers', 'formal', 'tailored'],
      description: 'Refined wool-blend trousers with a ceremonial silhouette and all-night comfort for wedding events.',
      story: 'They round out the marriage collection with a practical formal separate for receptions and guest styling.',
      highlights: const <String>['Refined wool-blend fabric', 'Ceremonial straight drape', 'Comfort waist construction'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_23', url: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'alloy_laptop_sleeve',
      title: 'Alloy Laptop Sleeve',
      tagline: 'Padded premium sleeve for daily carry and clean desk setups.',
      priceCents: 9200,
      heroImageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_circuit', handle: '@circuithouse', displayName: 'Circuit House'),
      inventory: const InventorySnapshot(availableCount: 28, totalCount: 120, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Work Carry'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 205, liveViewerCount: 58, hasReacted: false),
      tags: const <String>['laptop', 'sleeve', 'tech', 'bag', 'workspace'],
      description: 'A minimal laptop sleeve with soft lining, magnetic closure, and structured protection for portable work.',
      story: 'This is the clean everyday laptop carry layer, tuned for minimal work and travel searches.',
      highlights: const <String>['Soft protective lining', 'Magnetic close flap', 'Slim workspace profile'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_24', url: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
  ];
}
