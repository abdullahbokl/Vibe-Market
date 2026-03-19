import '../../domain/entities/product_entities.dart';

class CatalogSeedDataSource {
  late final DateTime _seedClock = DateTime.now().toUtc();
  late final List<ProductDetail> _products = List<ProductDetail>.unmodifiable(
    _buildProducts(),
  );
  late final Map<String, ProductDetail> _productsById =
      <String, ProductDetail>{
        for (final ProductDetail product in _products) product.summary.id: product,
      };
  late final List<ProductSummary> _summaries =
      List<ProductSummary>.unmodifiable(
        _products.map((ProductDetail item) => item.summary),
      );
  final Map<String, List<ProductSummary>> _searchCache =
      <String, List<ProductSummary>>{};

  List<ProductDetail> loadProducts() {
    return _products;
  }

  List<ProductDetail> _buildProducts() {
    final DateTime now = _seedClock;
    return <ProductDetail>[
      _buildProduct(
        id: 'obsidian_runner_jacket',
        title: 'Obsidian Runner Jacket',
        tagline: 'Light-reactive shell cut for after-dark drops.',
        priceCents: 24800,
        heroImageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_nova',
          handle: '@novalab',
          displayName: 'Nova Lab',
        ),
        inventory: const InventorySnapshot(
          availableCount: 14,
          totalCount: 60,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: now.add(const Duration(hours: 5, minutes: 18)),
          dropLabel: 'After Hours Drop',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 482,
          liveViewerCount: 126,
          hasReacted: false,
        ),
        tags: const <String>['outerwear', 'night-run', 'limited'],
        description:
            'A premium shell with reflective detailing, storm cuffs, and a tapered performance cut that keeps the silhouette sharp on and off the street.',
        story:
            'Designed around late-city movement, this drop pairs technical weather shielding with a dress-level drape so the piece feels premium in motion and in stills.',
        highlights: const <String>[
          'Reflective seam piping',
          'Water-resistant micro-ripstop',
          'Limited batch numbering',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_1',
            url:
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
          ProductMedia(
            id: 'media_2',
            url:
                'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'gold_line_timepiece',
        title: 'Gold Line Timepiece',
        tagline: 'Satin black dial, champagne lume, 1-of-300.',
        priceCents: 32500,
        heroImageUrl:
            'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_aureate',
          handle: '@aureate',
          displayName: 'Aureate Goods',
        ),
        inventory: const InventorySnapshot(
          availableCount: 33,
          totalCount: 300,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Collectors Window',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 214,
          liveViewerCount: 74,
          hasReacted: false,
        ),
        tags: const <String>['watch', 'collectors', 'luxury'],
        description:
            'Machined steel casework, matte black dial treatment, and a restrained gold seconds track that reads premium without becoming loud.',
        story:
            'The piece was built for the user who wants drop culture energy in a form that still feels timeless at dinner, at work, and in a lineup shot.',
        highlights: const <String>[
          '300-unit production cap',
          'Japanese automatic movement',
          'Sapphire-coated crystal',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_3',
            url:
                'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
          ProductMedia(
            id: 'media_4',
            url:
                'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'pulse_audio_case',
        title: 'Pulse Audio Case',
        tagline: 'Carbon shell carry for premium listening kits.',
        priceCents: 11800,
        heroImageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_echo',
          handle: '@echoatelier',
          displayName: 'Echo Atelier',
        ),
        inventory: const InventorySnapshot(
          availableCount: 8,
          totalCount: 40,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: now.add(const Duration(hours: 2, minutes: 7)),
          dropLabel: 'Flash Capsule',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 561,
          liveViewerCount: 208,
          hasReacted: false,
        ),
        tags: const <String>['audio', 'accessory', 'flash-sale'],
        description:
            'Compact shell case for over-ear or premium in-ear setups, with velvet-lined compartments and anodized hardware designed for fast travel.',
        story:
            'This accessory drop is built for creators who carry a full sonic identity with them and still want the unboxing moment to feel elevated.',
        highlights: const <String>[
          'Velvet-lined shell',
          'Low-profile hardware',
          'Serialized drop card included',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_5',
            url:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
          ProductMedia(
            id: 'media_6',
            url:
                'https://images.unsplash.com/photo-1496957961599-e35b69ef5d7c?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'noir_carry_duffel',
        title: 'Noir Carry Duffel',
        tagline: 'Soft-structured weekender with hidden utility grid.',
        priceCents: 18900,
        heroImageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_veil',
          handle: '@veilworks',
          displayName: 'Veil Works',
        ),
        inventory: const InventorySnapshot(
          availableCount: 21,
          totalCount: 90,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Weekend Reserve',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 307,
          liveViewerCount: 89,
          hasReacted: false,
        ),
        tags: const <String>['travel', 'bag', 'minimal'],
        description:
            'Structured enough to look composed in hand, soft enough to move with you, and packed with hidden slotting for shoes, cables, and documents.',
        story:
            'The duffel is the answer to short-haul movement for buyers who want premium restraint and practical storage without visible clutter.',
        highlights: const <String>[
          'Hidden side organization grid',
          'Coated canvas exterior',
          'Convertible shoulder system',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_7',
            url:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
          ProductMedia(
            id: 'media_8',
            url:
                'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'ember_court_sneakers',
        title: 'Ember Court Sneakers',
        tagline: 'Low-profile leather runner with warm copper accents.',
        priceCents: 21400,
        heroImageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_district',
          handle: '@districtassembly',
          displayName: 'District Assembly',
        ),
        inventory: const InventorySnapshot(
          availableCount: 17,
          totalCount: 75,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Street Rotation',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 418,
          liveViewerCount: 132,
          hasReacted: false,
        ),
        tags: const <String>['sneakers', 'footwear', 'runner', 'streetwear'],
        description:
            'Street-ready sneakers with premium leather panels, comfort foam, and subtle metallic accents designed for all-day rotation.',
        story:
            'This pair sits between performance runner energy and premium casual styling, which makes it ideal for testing vibe-driven search prompts.',
        highlights: const <String>[
          'Soft-touch leather upper',
          'Copper accent hardware',
          'Cushioned city sole',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_9',
            url:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'atlas_pour_over_set',
        title: 'Atlas Pour-Over Set',
        tagline: 'Stoneware brew ritual kit for slow morning drops.',
        priceCents: 9800,
        heroImageUrl:
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_meridian',
          handle: '@housemeridian',
          displayName: 'House Meridian',
        ),
        inventory: const InventorySnapshot(
          availableCount: 28,
          totalCount: 110,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Morning Ritual',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 275,
          liveViewerCount: 81,
          hasReacted: false,
        ),
        tags: const <String>['coffee', 'brew', 'pour-over', 'cafe', 'home'],
        description:
            'A coffee ritual set with dripper, server, and tactile cups that makes home brewing feel like a premium drop experience.',
        story:
            'The set adds a softer lifestyle angle to the catalog so search can be tested beyond apparel and accessories.',
        highlights: const <String>[
          'Textured stoneware finish',
          'Balanced pour geometry',
          'Gift-ready packaging',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_10',
            url:
                'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'halo_desk_lamp',
        title: 'Halo Desk Lamp',
        tagline: 'Soft ambient beam built for focused night sessions.',
        priceCents: 13200,
        heroImageUrl:
            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_still',
          handle: '@stillform',
          displayName: 'Still Form',
        ),
        inventory: const InventorySnapshot(
          availableCount: 19,
          totalCount: 80,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Studio Focus',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 193,
          liveViewerCount: 57,
          hasReacted: false,
        ),
        tags: const <String>['desk', 'workspace', 'lighting', 'minimal'],
        description:
            'A compact desk lamp with dimmable warmth, studio-ready glow, and a clean silhouette for focused evening work.',
        story:
            'This product gives the search system a workspace and productivity cluster that should respond to mood-based prompts.',
        highlights: const <String>[
          'Dimmable warm beam',
          'Weighted metal base',
          'Small-footprint design',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_11',
            url:
                'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'meridian_camera_sling',
        title: 'Meridian Camera Sling',
        tagline: 'Compact creator carry with padded lens bays.',
        priceCents: 15600,
        heroImageUrl:
            'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_frame',
          handle: '@framestate',
          displayName: 'Frame State',
        ),
        inventory: const InventorySnapshot(
          availableCount: 12,
          totalCount: 45,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Creator Pack',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 361,
          liveViewerCount: 109,
          hasReacted: false,
        ),
        tags: const <String>['camera', 'photography', 'bag', 'creator'],
        description:
            'A travel sling for mirrorless kits, batteries, and creator essentials with weather-safe structure and quick access.',
        story:
            'The camera sling adds a creator-tech cluster that should surface for photography, travel, and gear-organizer searches.',
        highlights: const <String>[
          'Padded lens dividers',
          'Weather-safe shell',
          'Quick side access',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_12',
            url:
                'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'velvet_smoke_fragrance',
        title: 'Velvet Smoke Fragrance',
        tagline: 'Warm amber scent with suede, cedar, and dusk spice.',
        priceCents: 14200,
        heroImageUrl:
            'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_quiet',
          handle: '@quietarchive',
          displayName: 'Quiet Archive',
        ),
        inventory: const InventorySnapshot(
          availableCount: 26,
          totalCount: 140,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Evening Ritual',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 287,
          liveViewerCount: 68,
          hasReacted: false,
        ),
        tags: const <String>['fragrance', 'perfume', 'luxury', 'evening'],
        description:
            'A limited fragrance release with soft smoke, amber resin, and skin-close woods for elegant night wear.',
        story:
            'This gives the semantic layer a scent and mood category, which is useful for testing broader lifestyle language.',
        highlights: const <String>[
          'Amber and cedar core',
          'Soft suede opening',
          'Collector-style bottle',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_13',
            url:
                'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'tidebreaker_sailing_shell',
        title: 'Tidebreaker Sailing Shell',
        tagline: 'Salt-ready outer layer built for wind, spray, and marina nights.',
        priceCents: 23600,
        heroImageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_harbor',
          handle: '@harbordivision',
          displayName: 'Harbor Division',
        ),
        inventory: const InventorySnapshot(
          availableCount: 18,
          totalCount: 70,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: now.add(const Duration(hours: 14, minutes: 11)),
          dropLabel: 'Blue Current',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 246,
          liveViewerCount: 77,
          hasReacted: false,
        ),
        tags: const <String>['sea', 'sailing', 'jacket', 'coastal', 'outerwear'],
        description:
            'A technical sea jacket with storm zip shielding, breathable lining, and a premium deck-ready silhouette.',
        story:
            'Built for bright water, cold spray, and marina movement, this shell gives the catalog a true coastal performance piece.',
        highlights: const <String>[
          'Storm-ready front placket',
          'Breathable lining',
          'Deck-focused mobility cut',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_14',
            url:
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'azure_deck_sandals',
        title: 'Azure Deck Sandals',
        tagline: 'Grip-soled sandals for hot piers and bright water days.',
        priceCents: 8400,
        heroImageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_shoreline',
          handle: '@shorelineatelier',
          displayName: 'Shoreline Atelier',
        ),
        inventory: const InventorySnapshot(
          availableCount: 30,
          totalCount: 140,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Sun Pier',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 188,
          liveViewerCount: 61,
          hasReacted: false,
        ),
        tags: const <String>['sea', 'sandals', 'beach', 'travel', 'summer'],
        description:
            'Minimal premium sandals with fast-dry straps and soft foam support for sea trips and beach clubs.',
        story:
            'These sandals are built for summer movement and give search a casual sea-day footwear option.',
        highlights: const <String>[
          'Fast-dry web straps',
          'Soft foam footbed',
          'High-grip sole pattern',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_15',
            url:
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'marina_weekend_tote',
        title: 'Marina Weekend Tote',
        tagline: 'Oversized carry-all for towels, sunscreen, and sea-day extras.',
        priceCents: 12800,
        heroImageUrl:
            'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_coast',
          handle: '@coasttheory',
          displayName: 'Coast Theory',
        ),
        inventory: const InventorySnapshot(
          availableCount: 24,
          totalCount: 90,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Harbor Carry',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 214,
          liveViewerCount: 66,
          hasReacted: false,
        ),
        tags: const <String>['sea', 'beach', 'tote', 'bag', 'weekend'],
        description:
            'A structured tote with coated canvas, internal bottle holders, and a soft coastal palette for boat and beach days.',
        story:
            'The marina tote brings a relaxed premium travel mood into the catalog and gives sea-related searches a carry accessory.',
        highlights: const <String>[
          'Coated canvas shell',
          'Oversized carry volume',
          'Internal bottle sleeves',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_16',
            url:
                'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'reef_stripe_towel_set',
        title: 'Reef Stripe Towel Set',
        tagline: 'Heavy cotton towels with resort-weight softness.',
        priceCents: 7600,
        heroImageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_tidal',
          handle: '@tidalhome',
          displayName: 'Tidal Home',
        ),
        inventory: const InventorySnapshot(
          availableCount: 36,
          totalCount: 180,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Cabana Stack',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 153,
          liveViewerCount: 49,
          hasReacted: false,
        ),
        tags: const <String>['sea', 'towel', 'beach', 'resort', 'summer'],
        description:
            'A premium towel bundle for sea escapes, with oversized weave, absorbent loops, and clean striped detailing.',
        story:
            'This set adds a resort and leisure layer to the catalog for beach and poolside semantic prompts.',
        highlights: const <String>[
          'Resort-weight cotton',
          'Oversized weave texture',
          'Quick-dry absorbency',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_17',
            url:
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'coastline_snorkel_kit',
        title: 'Coastline Snorkel Kit',
        tagline: 'Clear-view mask and low-drag fins for bright-water mornings.',
        priceCents: 15400,
        heroImageUrl:
            'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_bluearc',
          handle: '@bluearc',
          displayName: 'Blue Arc',
        ),
        inventory: const InventorySnapshot(
          availableCount: 15,
          totalCount: 60,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Open Water',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 198,
          liveViewerCount: 58,
          hasReacted: false,
        ),
        tags: const <String>['sea', 'snorkel', 'travel', 'water-sport', 'beach'],
        description:
            'A premium snorkel starter set with anti-fog lens treatment, travel mesh bag, and sea-ready comfort fit.',
        story:
            'It rounds out the sea cluster with an activity-driven product instead of another apparel item.',
        highlights: const <String>[
          'Anti-fog clear-view mask',
          'Travel mesh carry bag',
          'Comfort-fit snorkel mouthpiece',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_18',
            url:
                'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'ivory_vow_silk_shirt',
        title: 'Ivory Vow Silk Shirt',
        tagline: 'Soft-shine ceremony shirt cut for wedding light.',
        priceCents: 17200,
        heroImageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_maison',
          handle: '@maisonthread',
          displayName: 'Maison Thread',
        ),
        inventory: const InventorySnapshot(
          availableCount: 14,
          totalCount: 55,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Ceremony Edit',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 266,
          liveViewerCount: 92,
          hasReacted: false,
        ),
        tags: const <String>['marriage', 'wedding', 'shirt', 'formal', 'ceremony'],
        description:
            'A premium silk-blend shirt tailored for marriage celebrations, formal portraits, and clean tuxedo layering.',
        story:
            'This gives wedding search a polished core formalwear piece suited to ceremony and reception styling.',
        highlights: const <String>[
          'Silk-blend formal fabric',
          'Ceremony-ready collar shape',
          'Portrait-friendly sheen',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_19',
            url:
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'midnight_ceremony_blazer',
        title: 'Midnight Ceremony Blazer',
        tagline: 'Structured formal jacket with satin-edge restraint.',
        priceCents: 31400,
        heroImageUrl:
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_blackroom',
          handle: '@blackroomtailor',
          displayName: 'Blackroom Tailor',
        ),
        inventory: const InventorySnapshot(
          availableCount: 11,
          totalCount: 40,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: now.add(const Duration(hours: 29, minutes: 8)),
          dropLabel: 'Reception Night',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 322,
          liveViewerCount: 101,
          hasReacted: false,
        ),
        tags: const <String>['marriage', 'wedding', 'blazer', 'formal', 'luxury'],
        description:
            'A deep navy blazer made for marriage receptions and black-tie entrances, with sharp lines and soft movement.',
        story:
            'This blazer anchors formal wedding queries and adds a stronger tailoring signal to the semantic catalog.',
        highlights: const <String>[
          'Satin-edge detailing',
          'Tailored evening structure',
          'Reception-ready movement',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_20',
            url:
                'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'champagne_veil_dress',
        title: 'Champagne Veil Dress',
        tagline: 'Fluid satin dress designed for elegant wedding movement.',
        priceCents: 28600,
        heroImageUrl:
            'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_velour',
          handle: '@velourhall',
          displayName: 'Velour Hall',
        ),
        inventory: const InventorySnapshot(
          availableCount: 9,
          totalCount: 32,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Golden Aisle',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 341,
          liveViewerCount: 118,
          hasReacted: false,
        ),
        tags: const <String>['marriage', 'wedding', 'dress', 'formal', 'occasion'],
        description:
            'A refined occasion dress for marriage celebrations with soft drape, luminous fabric, and quiet statement energy.',
        story:
            'It brings a more expressive weddingwear silhouette into the catalog for feminine formal and guest-ceremony searches.',
        highlights: const <String>[
          'Fluid satin drape',
          'Elegant ceremony silhouette',
          'Soft evening sheen',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_21',
            url:
                'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'pearl_evening_heels',
        title: 'Pearl Evening Heels',
        tagline: 'Satin heels with ceremony-friendly comfort and glow.',
        priceCents: 19800,
        heroImageUrl:
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_lune',
          handle: '@luneatelier',
          displayName: 'Lune Atelier',
        ),
        inventory: const InventorySnapshot(
          availableCount: 13,
          totalCount: 48,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Reception Steps',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 224,
          liveViewerCount: 83,
          hasReacted: false,
        ),
        tags: const <String>['marriage', 'wedding', 'heels', 'formal', 'shoes'],
        description:
            'Elegant formal heels designed for wedding looks, long receptions, and premium evening styling.',
        story:
            'These heels extend wedding-related search beyond garments and into formal accessories with occasion intent.',
        highlights: const <String>[
          'Satin evening finish',
          'Comfort-tuned heel pitch',
          'Ceremony-ready profile',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_22',
            url:
                'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'tailored_vow_trousers',
        title: 'Tailored Vow Trousers',
        tagline: 'Clean formal drape for marriage weekends and late receptions.',
        priceCents: 16400,
        heroImageUrl:
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_chapel',
          handle: '@northchapel',
          displayName: 'North Chapel',
        ),
        inventory: const InventorySnapshot(
          availableCount: 16,
          totalCount: 64,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Formal Line',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 191,
          liveViewerCount: 63,
          hasReacted: false,
        ),
        tags: const <String>['marriage', 'wedding', 'trousers', 'formal', 'tailored'],
        description:
            'Refined wool-blend trousers with a ceremonial silhouette and all-night comfort for wedding events.',
        story:
            'They round out the marriage collection with a practical formal separate for receptions and guest styling.',
        highlights: const <String>[
          'Refined wool-blend fabric',
          'Ceremonial straight drape',
          'Comfort waist construction',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_23',
            url:
                'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'alloy_laptop_sleeve',
        title: 'Alloy Laptop Sleeve',
        tagline: 'Padded premium sleeve for daily carry and clean desk setups.',
        priceCents: 9200,
        heroImageUrl:
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_circuit',
          handle: '@circuithouse',
          displayName: 'Circuit House',
        ),
        inventory: const InventorySnapshot(
          availableCount: 28,
          totalCount: 120,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Work Carry',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 205,
          liveViewerCount: 58,
          hasReacted: false,
        ),
        tags: const <String>['laptop', 'sleeve', 'tech', 'bag', 'workspace'],
        description:
            'A minimal laptop sleeve with soft lining, magnetic closure, and structured protection for portable work.',
        story:
            'This is the clean everyday laptop carry layer, tuned for minimal work and travel searches.',
        highlights: const <String>[
          'Soft protective lining',
          'Magnetic close flap',
          'Slim workspace profile',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_24',
            url:
                'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'vector_portable_monitor',
        title: 'Vector Portable Monitor',
        tagline: 'Slim second screen for travel editing and dual-screen focus.',
        priceCents: 27900,
        heroImageUrl:
            'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_display',
          handle: '@displaybureau',
          displayName: 'Display Bureau',
        ),
        inventory: const InventorySnapshot(
          availableCount: 10,
          totalCount: 38,
          isLowStock: true,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: now.add(const Duration(hours: 31, minutes: 5)),
          dropLabel: 'Dual View',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 286,
          liveViewerCount: 90,
          hasReacted: false,
        ),
        tags: const <String>['laptop', 'monitor', 'tech', 'workspace', 'productivity'],
        description:
            'A premium portable monitor for laptop workflows, creators, and remote setup flexibility.',
        story:
            'It makes the laptop cluster feel more complete for creator, second-screen, and travel workstation search prompts.',
        highlights: const <String>[
          'Slim travel form',
          'Dual-screen productivity',
          'Creator-friendly display profile',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_25',
            url:
                'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'keystone_mechanical_keyboard',
        title: 'Keystone Mechanical Keyboard',
        tagline: 'Compact tactile board tuned for laptop-first desks.',
        priceCents: 14300,
        heroImageUrl:
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_input',
          handle: '@inputstandard',
          displayName: 'Input Standard',
        ),
        inventory: const InventorySnapshot(
          availableCount: 21,
          totalCount: 88,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Typing Room',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 192,
          liveViewerCount: 60,
          hasReacted: false,
        ),
        tags: const <String>['laptop', 'keyboard', 'tech', 'desk', 'workspace'],
        description:
            'A premium wireless keyboard with crisp switches, compact footprint, and all-day typing comfort for laptop users.',
        story:
            'This one strengthens the productivity and desk-setup side of laptop search behavior.',
        highlights: const <String>[
          'Compact tactile layout',
          'Wireless desk pairing',
          'All-day typing comfort',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_26',
            url:
                'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'dockline_usbc_hub',
        title: 'Dockline USB-C Hub',
        tagline: 'Desk dock that turns one laptop port into a full studio.',
        priceCents: 11200,
        heroImageUrl:
            'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_port',
          handle: '@portstandard',
          displayName: 'Port Standard',
        ),
        inventory: const InventorySnapshot(
          availableCount: 26,
          totalCount: 96,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Port Stack',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 178,
          liveViewerCount: 54,
          hasReacted: false,
        ),
        tags: const <String>['laptop', 'usb-c', 'hub', 'desk', 'tech'],
        description:
            'A premium multi-port USB-C hub for laptop charging, display output, storage, and creator desk setups.',
        story:
            'The hub adds a more technical laptop utility item so semantic search can distinguish carry from workstation accessories.',
        highlights: const <String>[
          'Multi-port desk expansion',
          'Display and storage support',
          'Compact creator dock',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_27',
            url:
                'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      _buildProduct(
        id: 'arc_travel_laptop_charger',
        title: 'Arc Travel Laptop Charger',
        tagline: 'High-output compact charger for laptops, phones, and airport days.',
        priceCents: 9600,
        heroImageUrl:
            'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
        seller: const SellerSummary(
          id: 'seller_watt',
          handle: '@wattform',
          displayName: 'Watt Form',
        ),
        inventory: const InventorySnapshot(
          availableCount: 34,
          totalCount: 150,
          isLowStock: false,
        ),
        dropMetadata: DropMetadata(
          saleEndTime: null,
          dropLabel: 'Power Lane',
        ),
        reactionSnapshot: const ReactionSnapshot(
          reactionCount: 165,
          liveViewerCount: 51,
          hasReacted: false,
        ),
        tags: const <String>['laptop', 'charger', 'travel', 'tech', 'power'],
        description:
            'A fast-charging GaN power brick built for laptop travel kits, shared charging, and light carry.',
        story:
            'This gives the laptop category a practical travel-power product that should respond well to mobile office queries.',
        highlights: const <String>[
          'Compact GaN build',
          'High-output fast charging',
          'Travel-friendly cable setup',
        ],
        gallery: const <ProductMedia>[
          ProductMedia(
            id: 'media_28',
            url:
                'https://images.unsplash.com/photo-1517336714739-489689fd1ca8?auto=format&fit=crop&w=1200&q=80',
            type: 'image',
          ),
        ],
      ),
      ..._buildExpandedClothingCatalog(),
    ];
  }

  ProductDetail? getById(String productId) {
    return _productsById[productId];
  }

  List<ProductSummary> listSummaries() {
    return _summaries;
  }

  List<ProductSummary> search(String query) {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return _summaries;
    }

    final List<ProductSummary>? cached = _searchCache[normalized];
    if (cached != null) {
      return cached;
    }

    final List<_ScoredSummary> matches =
        _summaries
            .map(
              (ProductSummary summary) =>
                  _ScoredSummary(summary, _score(summary, normalized)),
            )
            .where((_ScoredSummary item) => item.score > 0)
            .toList()
          ..sort(
            (_ScoredSummary a, _ScoredSummary b) => b.score.compareTo(a.score),
          );

    final List<ProductSummary> results = List<ProductSummary>.unmodifiable(
      matches.map((_ScoredSummary item) => item.summary),
    );
    _searchCache[normalized] = results;
    return results;
  }

  ProductDetail _buildProduct({
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

  List<ProductDetail> _buildExpandedClothingCatalog() {
    const List<_GeneratedClothingSeed> seeds = <_GeneratedClothingSeed>[
      _GeneratedClothingSeed(id: 'sea_breeze_linen_shirt', title: 'Sea Breeze Linen Shirt', tagline: 'Breathable linen button-up for bright harbor mornings.', priceCents: 12600, collection: 'Sea Edit', imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', tags: <String>['sea', 'linen', 'shirt', 'coastal']),
      _GeneratedClothingSeed(id: 'wavecrest_drawstring_shorts', title: 'Wavecrest Drawstring Shorts', tagline: 'Relaxed shorts cut for deck walks and beach afternoons.', priceCents: 8400, collection: 'Sea Edit', imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', tags: <String>['sea', 'shorts', 'beach', 'summer']),
      _GeneratedClothingSeed(id: 'harbor_knit_polo', title: 'Harbor Knit Polo', tagline: 'Soft coastal knit for resort dinners and marina weekends.', priceCents: 11800, collection: 'Sea Edit', imageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80', tags: <String>['sea', 'polo', 'knit', 'resort']),
      _GeneratedClothingSeed(id: 'saltline_cover_trousers', title: 'Saltline Cover Trousers', tagline: 'Lightweight trousers for sea travel and quiet luxury styling.', priceCents: 14200, collection: 'Sea Edit', imageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=1200&q=80', tags: <String>['sea', 'trousers', 'travel', 'minimal']),
      _GeneratedClothingSeed(id: 'marina_rib_tank', title: 'Marina Rib Tank', tagline: 'Close-fit tank for heat, sand, and layered summer looks.', priceCents: 6200, collection: 'Sea Edit', imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80', tags: <String>['sea', 'tank', 'summer', 'beach']),
      _GeneratedClothingSeed(id: 'velocity_track_jacket', title: 'Velocity Track Jacket', tagline: 'Performance layer built for warm-up laps and city runs.', priceCents: 15400, collection: 'Sports Studio', imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80', tags: <String>['sports', 'track', 'jacket', 'running']),
      _GeneratedClothingSeed(id: 'apex_training_shorts', title: 'Apex Training Shorts', tagline: 'Ultra-light shorts for gym sets and sprint sessions.', priceCents: 7600, collection: 'Sports Studio', imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80', tags: <String>['sports', 'shorts', 'training', 'gym']),
      _GeneratedClothingSeed(id: 'summit_compression_top', title: 'Summit Compression Top', tagline: 'Supportive long sleeve for high-output training blocks.', priceCents: 9800, collection: 'Sports Studio', imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80', tags: <String>['sports', 'top', 'training', 'performance']),
      _GeneratedClothingSeed(id: 'baseline_court_skirt', title: 'Baseline Court Skirt', tagline: 'Sport pleat silhouette for tennis, padel, and active styling.', priceCents: 11200, collection: 'Sports Studio', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['sports', 'skirt', 'tennis', 'active']),
      _GeneratedClothingSeed(id: 'relay_performance_hoodie', title: 'Relay Performance Hoodie', tagline: 'Soft recovery hoodie with athletic drape and stretch.', priceCents: 13600, collection: 'Sports Studio', imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80', tags: <String>['sports', 'hoodie', 'training', 'recovery']),
      _GeneratedClothingSeed(id: 'neon_alley_cargo_pants', title: 'Neon Alley Cargo Pants', tagline: 'Street cargo silhouette with utility pockets and relaxed shape.', priceCents: 16800, collection: 'Street Uniform', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['streetwear', 'cargo', 'pants', 'utility']),
      _GeneratedClothingSeed(id: 'district_graphic_tee', title: 'District Graphic Tee', tagline: 'Heavyweight street tee with bold front placement art.', priceCents: 6800, collection: 'Street Uniform', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['streetwear', 'tee', 'graphic', 'cotton']),
      _GeneratedClothingSeed(id: 'concrete_bomber_shell', title: 'Concrete Bomber Shell', tagline: 'Cropped bomber built for layered street fits after dark.', priceCents: 18400, collection: 'Street Uniform', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['streetwear', 'bomber', 'jacket', 'night']),
      _GeneratedClothingSeed(id: 'signal_patch_hoodie', title: 'Signal Patch Hoodie', tagline: 'Relaxed fleece hoodie with understated street insignia.', priceCents: 12400, collection: 'Street Uniform', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['streetwear', 'hoodie', 'fleece', 'casual']),
      _GeneratedClothingSeed(id: 'metro_panel_jeans', title: 'Metro Panel Jeans', tagline: 'Wide-leg denim with stitched panel lines and worn depth.', priceCents: 14600, collection: 'Street Uniform', imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=1200&q=80', tags: <String>['streetwear', 'jeans', 'denim', 'wide-leg']),
      _GeneratedClothingSeed(id: 'forge_canvas_overshirt', title: 'Forge Canvas Overshirt', tagline: 'Structured work shirt for studio hours and hard-wearing daily use.', priceCents: 15200, collection: 'Workday Tailored', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['workwear', 'overshirt', 'canvas', 'utility']),
      _GeneratedClothingSeed(id: 'ledger_taper_trousers', title: 'Ledger Taper Trousers', tagline: 'Clean office trouser with stretch comfort and sharp line.', priceCents: 13800, collection: 'Workday Tailored', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['workwear', 'trousers', 'office', 'tailored']),
      _GeneratedClothingSeed(id: 'briefing_merino_polo', title: 'Briefing Merino Polo', tagline: 'Refined polo for business-casual dressing and calm polish.', priceCents: 11600, collection: 'Workday Tailored', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['workwear', 'polo', 'merino', 'office']),
      _GeneratedClothingSeed(id: 'atelier_shift_dress', title: 'Atelier Shift Dress', tagline: 'Minimal shift dress for studio work and polished weekdays.', priceCents: 17200, collection: 'Workday Tailored', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['workwear', 'dress', 'minimal', 'office']),
      _GeneratedClothingSeed(id: 'foundry_utility_vest', title: 'Foundry Utility Vest', tagline: 'Layered vest with refined pockets for creative workdays.', priceCents: 12900, collection: 'Workday Tailored', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['workwear', 'vest', 'utility', 'studio']),
      _GeneratedClothingSeed(id: 'cloudsoft_jersey_set', title: 'Cloudsoft Jersey Set', tagline: 'Matching lounge set built for quiet mornings and recovery days.', priceCents: 14800, collection: 'Soft Living', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['loungewear', 'set', 'jersey', 'comfort']),
      _GeneratedClothingSeed(id: 'dusk_plush_robe', title: 'Dusk Plush Robe', tagline: 'Hotel-weight robe for soft evenings and slow starts.', priceCents: 13200, collection: 'Soft Living', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['loungewear', 'robe', 'soft', 'home']),
      _GeneratedClothingSeed(id: 'quiet_hour_pajama_shirt', title: 'Quiet Hour Pajama Shirt', tagline: 'Relaxed sleep shirt with premium drape and cool touch.', priceCents: 9400, collection: 'Soft Living', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['loungewear', 'pajama', 'shirt', 'sleep']),
      _GeneratedClothingSeed(id: 'ember_fleece_pants', title: 'Ember Fleece Pants', tagline: 'Warm brushed fleece for everyday comfort and travel rest.', priceCents: 8800, collection: 'Soft Living', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['loungewear', 'pants', 'fleece', 'comfort']),
      _GeneratedClothingSeed(id: 'cocoon_wrap_cardigan', title: 'Cocoon Wrap Cardigan', tagline: 'Soft cardigan layer with quiet luxury volume and ease.', priceCents: 11400, collection: 'Soft Living', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['loungewear', 'cardigan', 'knit', 'soft']),
      _GeneratedClothingSeed(id: 'vowline_satin_blouse', title: 'Vowline Satin Blouse', tagline: 'Elegant blouse for rehearsal dinners and wedding weekends.', priceCents: 15200, collection: 'Ceremony Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['wedding', 'blouse', 'formal', 'ceremony']),
      _GeneratedClothingSeed(id: 'chapel_tailored_vest', title: 'Chapel Tailored Vest', tagline: 'Structured vest layer for formal marriage styling.', priceCents: 12400, collection: 'Ceremony Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['wedding', 'vest', 'tailored', 'formal']),
      _GeneratedClothingSeed(id: 'aisle_crepe_skirt', title: 'Aisle Crepe Skirt', tagline: 'Fluid crepe skirt for ceremony elegance and evening movement.', priceCents: 13800, collection: 'Ceremony Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['wedding', 'skirt', 'crepe', 'occasion']),
      _GeneratedClothingSeed(id: 'reception_silk_tie_set', title: 'Reception Silk Tie Set', tagline: 'Polished silk tie collection for formal dress codes.', priceCents: 7200, collection: 'Ceremony Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['wedding', 'tie', 'silk', 'formal']),
      _GeneratedClothingSeed(id: 'pearl_hem_evening_coat', title: 'Pearl Hem Evening Coat', tagline: 'Light ceremony coat for polished entrances and late departures.', priceCents: 19800, collection: 'Ceremony Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['wedding', 'coat', 'formal', 'luxury']),
      _GeneratedClothingSeed(id: 'nomad_packable_anorak', title: 'Nomad Packable Anorak', tagline: 'Travel layer that folds small and wears sharp on arrival.', priceCents: 14400, collection: 'Travel Layers', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['travel', 'anorak', 'packable', 'outerwear']),
      _GeneratedClothingSeed(id: 'transit_pull_on_pants', title: 'Transit Pull-On Pants', tagline: 'Wrinkle-light travel pants with polished comfort.', priceCents: 11200, collection: 'Travel Layers', imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=1200&q=80', tags: <String>['travel', 'pants', 'comfort', 'minimal']),
      _GeneratedClothingSeed(id: 'journey_softshell_vest', title: 'Journey Softshell Vest', tagline: 'Layering vest for terminal mornings and light-weather movement.', priceCents: 10800, collection: 'Travel Layers', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['travel', 'vest', 'softshell', 'layer']),
      _GeneratedClothingSeed(id: 'boarding_merino_crew', title: 'Boarding Merino Crew', tagline: 'Temperature-smart knit for long flights and cool lounges.', priceCents: 11800, collection: 'Travel Layers', imageUrl: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=1200&q=80', tags: <String>['travel', 'merino', 'knit', 'crew']),
      _GeneratedClothingSeed(id: 'carryon_shirt_dress', title: 'Carryon Shirt Dress', tagline: 'Easy travel dress with clean shape and all-day range.', priceCents: 14600, collection: 'Travel Layers', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['travel', 'dress', 'minimal', 'easy-wear']),
      _GeneratedClothingSeed(id: 'drift_puffer_vest', title: 'Drift Puffer Vest', tagline: 'Light insulated vest for layering through shifting weather.', priceCents: 13400, collection: 'Outerline', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['outerwear', 'vest', 'puffer', 'layer']),
      _GeneratedClothingSeed(id: 'ridge_wool_overcoat', title: 'Ridge Wool Overcoat', tagline: 'Clean long coat with everyday premium weight and drape.', priceCents: 24800, collection: 'Outerline', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['outerwear', 'coat', 'wool', 'minimal']),
      _GeneratedClothingSeed(id: 'summit_quilt_liner', title: 'Summit Quilt Liner', tagline: 'Light quilted jacket that keeps structure without bulk.', priceCents: 15600, collection: 'Outerline', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['outerwear', 'quilted', 'jacket', 'layer']),
      _GeneratedClothingSeed(id: 'shadow_rain_mac', title: 'Shadow Rain Mac', tagline: 'Minimal raincoat with polished finish and city-ready cut.', priceCents: 17200, collection: 'Outerline', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['outerwear', 'raincoat', 'minimal', 'city']),
      _GeneratedClothingSeed(id: 'northfield_shearling_jacket', title: 'Northfield Shearling Jacket', tagline: 'Warm heritage jacket with soft lining and strong silhouette.', priceCents: 22600, collection: 'Outerline', imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80', tags: <String>['outerwear', 'shearling', 'jacket', 'winter']),
      _GeneratedClothingSeed(id: 'luna_slip_dress', title: 'Luna Slip Dress', tagline: 'Night-out slip dress with shine, movement, and calm drama.', priceCents: 16400, collection: 'After Dark Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['night-out', 'dress', 'evening', 'satin']),
      _GeneratedClothingSeed(id: 'velvet_hour_blazer', title: 'Velvet Hour Blazer', tagline: 'Soft structured blazer for dinner fits and late city plans.', priceCents: 18800, collection: 'After Dark Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['night-out', 'blazer', 'evening', 'tailored']),
      _GeneratedClothingSeed(id: 'midnight_mesh_top', title: 'Midnight Mesh Top', tagline: 'Layered mesh top for nightlife styling and bold contrast.', priceCents: 9200, collection: 'After Dark Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['night-out', 'top', 'mesh', 'layered']),
      _GeneratedClothingSeed(id: 'strobe_tailored_trousers', title: 'Strobe Tailored Trousers', tagline: 'Sharp evening trousers with fluid drape and long line.', priceCents: 14800, collection: 'After Dark Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['night-out', 'trousers', 'tailored', 'evening']),
      _GeneratedClothingSeed(id: 'moonlight_cropped_shirt', title: 'Moonlight Cropped Shirt', tagline: 'Clean cropped shirt for night styling and modern silhouettes.', priceCents: 9800, collection: 'After Dark Wardrobe', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['night-out', 'shirt', 'cropped', 'minimal']),
      _GeneratedClothingSeed(id: 'plainform_rib_tee', title: 'Plainform Rib Tee', tagline: 'Minimal rib tee for quiet wardrobes and clean layering.', priceCents: 5400, collection: 'Core Basics', imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80', tags: <String>['basics', 'tee', 'minimal', 'rib']),
      _GeneratedClothingSeed(id: 'linea_cotton_poplin_shirt', title: 'Linea Cotton Poplin Shirt', tagline: 'Crisp essential shirt with clean line and daily polish.', priceCents: 10200, collection: 'Core Basics', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=1200&q=80', tags: <String>['basics', 'shirt', 'cotton', 'minimal']),
      _GeneratedClothingSeed(id: 'frame_straight_jeans', title: 'Frame Straight Jeans', tagline: 'Minimal straight-leg denim for repeat everyday wear.', priceCents: 11400, collection: 'Core Basics', imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=1200&q=80', tags: <String>['basics', 'jeans', 'denim', 'everyday']),
      _GeneratedClothingSeed(id: 'calm_knit_tank', title: 'Calm Knit Tank', tagline: 'Refined knit tank for layering and warm-weather ease.', priceCents: 6800, collection: 'Core Basics', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['basics', 'tank', 'knit', 'minimal']),
      _GeneratedClothingSeed(id: 'quietline_jersey_skirt', title: 'Quietline Jersey Skirt', tagline: 'Soft jersey column skirt with understated movement.', priceCents: 8600, collection: 'Core Basics', imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1200&q=80', tags: <String>['basics', 'skirt', 'jersey', 'minimal']),
    ];

    return seeds.asMap().entries.map((MapEntry<int, _GeneratedClothingSeed> entry) {
      final int index = entry.key;
      final _GeneratedClothingSeed seed = entry.value;
      final String collectionKey = seed.collection
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
          .replaceAll(RegExp(r'_+'), '_')
          .replaceAll(RegExp(r'^_|_$'), '');
      final List<String> normalizedTags = seed.tags.toList();
      final List<String> highlights = normalizedTags.take(3).map((String tag) {
        return tag.replaceAll('-', ' ');
      }).toList();
      while (highlights.length < 3) {
        highlights.add(seed.collection);
      }
      final int availableCount = 12 + (index % 18);
      final int totalCount = availableCount + 42 + ((index % 5) * 9);

      return _buildProduct(
        id: seed.id,
        title: seed.title,
        tagline: seed.tagline,
        priceCents: seed.priceCents,
        heroImageUrl: seed.imageUrl,
        seller: SellerSummary(
          id: 'seller_$collectionKey',
          handle: '@$collectionKey',
          displayName: seed.collection,
        ),
        inventory: InventorySnapshot(
          availableCount: availableCount,
          totalCount: totalCount,
          isLowStock: availableCount <= 15,
        ),
        dropMetadata: DropMetadata(dropLabel: seed.collection),
        reactionSnapshot: ReactionSnapshot(
          reactionCount: 130 + (index * 17),
          liveViewerCount: 34 + (index % 7) * 11,
          hasReacted: false,
        ),
        tags: normalizedTags,
        description:
            '${seed.title} is built for ${seed.collection.toLowerCase()} styling, combining ${normalizedTags.take(3).join(', ')} cues with premium everyday wearability.',
        story:
            'This fake catalog piece is part of the ${seed.collection.toLowerCase()} group, added to strengthen semantic-search coverage for clothing-heavy shopping queries.',
        highlights: highlights,
        gallery: <ProductMedia>[
          ProductMedia(
            id: '${seed.id}_media_1',
            url: seed.imageUrl,
            type: 'image',
          ),
        ],
      );
    }).toList();
  }

  int _score(ProductSummary summary, String normalizedQuery) {
    int score = 0;
    if (summary.title.toLowerCase().contains(normalizedQuery)) {
      score += 6;
    }
    if (summary.tagline.toLowerCase().contains(normalizedQuery)) {
      score += 4;
    }
    if (summary.seller.displayName.toLowerCase().contains(normalizedQuery) ||
        summary.seller.handle.toLowerCase().contains(normalizedQuery)) {
      score += 3;
    }
    for (final String tag in summary.tags) {
      if (tag.toLowerCase().contains(normalizedQuery)) {
        score += 2;
      }
    }
    if (summary.inventory.isLowStock) {
      score += 1;
    }
    return score;
  }
}

class _ScoredSummary {
  const _ScoredSummary(this.summary, this.score);

  final ProductSummary summary;
  final int score;
}

class _GeneratedClothingSeed {
  const _GeneratedClothingSeed({
    required this.id,
    required this.title,
    required this.tagline,
    required this.priceCents,
    required this.collection,
    required this.imageUrl,
    required this.tags,
  });

  final String id;
  final String title;
  final String tagline;
  final int priceCents;
  final String collection;
  final String imageUrl;
  final List<String> tags;
}
