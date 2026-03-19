import 'package:equatable/equatable.dart';

import 'seller_summary.dart';
import 'snapshots.dart';

class ProductSummary extends Equatable {
  const ProductSummary({
    required this.id,
    required this.title,
    required this.tagline,
    required this.priceCents,
    required this.currencyCode,
    required this.heroImageUrl,
    required this.seller,
    required this.inventory,
    required this.dropMetadata,
    required this.reactionSnapshot,
    required this.tags,
  });

  final String id;
  final String title;
  final String tagline;
  final int priceCents;
  final String currencyCode;
  final String heroImageUrl;
  final SellerSummary seller;
  final InventorySnapshot inventory;
  final DropMetadata dropMetadata;
  final ReactionSnapshot reactionSnapshot;
  final List<String> tags;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    tagline,
    priceCents,
    currencyCode,
    heroImageUrl,
    seller,
    inventory,
    dropMetadata,
    reactionSnapshot,
    tags,
  ];
}
