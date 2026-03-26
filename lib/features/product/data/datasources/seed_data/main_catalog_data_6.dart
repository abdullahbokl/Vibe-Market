import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'catalog_product_builder.dart';

List<ProductDetail> getMainCatalogChunk6(DateTime now) {
  return <ProductDetail>[
    CatalogProductBuilder.build(
      id: 'vector_portable_monitor',
      title: 'Vector Portable Monitor',
      tagline: 'Slim second screen for travel editing and dual-screen focus.',
      priceCents: 27900,
      heroImageUrl: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_display', handle: '@displaybureau', displayName: 'Display Bureau'),
      inventory: const InventorySnapshot(availableCount: 10, totalCount: 38, isLowStock: true),
      dropMetadata: DropMetadata(saleEndTime: now.add(const Duration(hours: 31, minutes: 5)), dropLabel: 'Dual View'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 286, liveViewerCount: 90, hasReacted: false),
      tags: const <String>['laptop', 'monitor', 'tech', 'workspace', 'productivity'],
      description: 'A premium portable monitor for laptop workflows, creators, and remote setup flexibility.',
      story: 'It makes the laptop cluster feel more complete for creator, second-screen, and travel workstation search prompts.',
      highlights: const <String>['Slim travel form', 'Dual-screen productivity', 'Creator-friendly display profile'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_25', url: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'keystone_mechanical_keyboard',
      title: 'Keystone Mechanical Keyboard',
      tagline: 'Compact tactile board tuned for laptop-first desks.',
      priceCents: 14300,
      heroImageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_input', handle: '@inputstandard', displayName: 'Input Standard'),
      inventory: const InventorySnapshot(availableCount: 21, totalCount: 88, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Typing Room'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 192, liveViewerCount: 60, hasReacted: false),
      tags: const <String>['laptop', 'keyboard', 'tech', 'desk', 'workspace'],
      description: 'A premium wireless keyboard with crisp switches, compact footprint, and all-day typing comfort for laptop users.',
      story: 'This one strengthens the productivity and desk-setup side of laptop search behavior.',
      highlights: const <String>['Compact tactile layout', 'Wireless desk pairing', 'All-day typing comfort'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_26', url: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'dockline_usbc_hub',
      title: 'Dockline USB-C Hub',
      tagline: 'Desk dock that turns one laptop port into a full studio.',
      priceCents: 11200,
      heroImageUrl: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_port', handle: '@portstandard', displayName: 'Port Standard'),
      inventory: const InventorySnapshot(availableCount: 26, totalCount: 96, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Port Stack'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 178, liveViewerCount: 54, hasReacted: false),
      tags: const <String>['laptop', 'usb-c', 'hub', 'desk', 'tech'],
      description: 'A premium multi-port USB-C hub for laptop charging, display output, storage, and creator desk setups.',
      story: 'The hub adds a more technical laptop utility item so semantic search can distinguish carry from workstation accessories.',
      highlights: const <String>['Multi-port desk expansion', 'Display and storage support', 'Compact creator dock'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_27', url: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
    CatalogProductBuilder.build(
      id: 'arc_travel_laptop_charger',
      title: 'Arc Travel Laptop Charger',
      tagline: 'High-output compact charger for laptops, phones, and airport days.',
      priceCents: 9600,
      heroImageUrl: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
      seller: const SellerSummary(id: 'seller_watt', handle: '@wattform', displayName: 'Watt Form'),
      inventory: const InventorySnapshot(availableCount: 34, totalCount: 150, isLowStock: false),
      dropMetadata: const DropMetadata(saleEndTime: null, dropLabel: 'Power Lane'),
      reactionSnapshot: const ReactionSnapshot(reactionCount: 165, liveViewerCount: 51, hasReacted: false),
      tags: const <String>['laptop', 'charger', 'travel', 'tech', 'power'],
      description: 'A fast-charging GaN power brick built for laptop travel kits, shared charging, and light carry.',
      story: 'This gives the laptop category a practical travel-power product that should respond well to mobile office queries.',
      highlights: const <String>['Compact GaN build', 'High-output fast charging', 'Travel-friendly cable setup'],
      gallery: const <ProductMedia>[
        ProductMedia(id: 'media_28', url: 'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80', type: 'image'),
      ],
    ),
  ];
}
