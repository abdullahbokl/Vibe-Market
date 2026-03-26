import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'seed_data/catalog_product_builder.dart';
import 'seed_data/clothing_seed_data_1.dart';
import 'seed_data/clothing_seed_data_2.dart';
import 'seed_data/main_catalog_data_1.dart';
import 'seed_data/main_catalog_data_2.dart';
import 'seed_data/main_catalog_data_3.dart';
import 'seed_data/main_catalog_data_4.dart';
import 'seed_data/main_catalog_data_5.dart';
import 'seed_data/main_catalog_data_6.dart';
import 'seed_data/main_catalog_data_7.dart';

class CatalogSeedDataSource {
  CatalogSeedDataSource() {
    final DateTime now = DateTime.now();
    _products = _buildProducts(now);
    for (final ProductDetail product in _products) {
      _productsById[product.summary.id] = product;
      _summaries.add(product.summary);
    }
  }

  late final List<ProductDetail> _products;
  final Map<String, ProductDetail> _productsById = <String, ProductDetail>{};
  final List<ProductSummary> _summaries = <ProductSummary>[];
  final Map<String, List<ProductSummary>> _searchCache = <String, List<ProductSummary>>{};

  List<ProductDetail> _buildProducts(DateTime now) {
    return <ProductDetail>[
      ...getMainCatalogChunk1(now),
      ...getMainCatalogChunk2(now),
      ...getMainCatalogChunk3(now),
      ...getMainCatalogChunk4(now),
      ...getMainCatalogChunk5(now),
      ...getMainCatalogChunk6(now),
      ...getMainCatalogChunk7(now),
      ..._buildExpandedClothingCatalog(),
    ];
  }

  ProductDetail? getById(String productId) => _productsById[productId];

  List<ProductSummary> listSummaries() => _summaries;

  List<ProductSummary> search(String query) {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return _summaries;
    if (_searchCache.containsKey(normalized)) return _searchCache[normalized]!;

    final List<_ScoredSummary> results = _summaries
        .map((s) => _ScoredSummary(s, _score(s, normalized)))
        .where((item) => item.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final List<ProductSummary> finalResults = List.unmodifiable(results.map((item) => item.summary));
    _searchCache[normalized] = finalResults;
    return finalResults;
  }

  List<ProductDetail> _buildExpandedClothingCatalog() {
    final List<GeneratedClothingSeed> seeds = [...clothingSeeds, ...clothingSeeds2];
    return seeds.asMap().entries.map((entry) {
      final int index = entry.key;
      final GeneratedClothingSeed seed = entry.value;
      final String collectionKey = seed.collection.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
      final int availableCount = 12 + (index % 18);
      return CatalogProductBuilder.build(
        id: seed.id,
        title: seed.title,
        tagline: seed.tagline,
        priceCents: seed.priceCents,
        heroImageUrl: seed.imageUrl,
        seller: SellerSummary(id: 'seller_$collectionKey', handle: '@$collectionKey', displayName: seed.collection),
        inventory: InventorySnapshot(availableCount: availableCount, totalCount: availableCount + 42, isLowStock: availableCount <= 15),
        dropMetadata: DropMetadata(dropLabel: seed.collection),
        reactionSnapshot: ReactionSnapshot(reactionCount: 130 + (index * 17), liveViewerCount: 34 + (index % 7) * 11, hasReacted: false),
        tags: seed.tags,
        description: '${seed.title} is built for ${seed.collection.toLowerCase()} styling.',
        story: 'Part of the ${seed.collection} group.',
        highlights: seed.tags.take(3).toList(),
        gallery: [ProductMedia(id: '${seed.id}_m', url: seed.imageUrl, type: 'image')],
      );
    }).toList();
  }

  int _score(ProductSummary summary, String query) {
    int score = 0;
    if (summary.title.toLowerCase().contains(query)) score += 6;
    if (summary.tagline.toLowerCase().contains(query)) score += 4;
    return score;
  }
}

class _ScoredSummary {
  const _ScoredSummary(this.summary, this.score);
  final ProductSummary summary;
  final int score;
}
