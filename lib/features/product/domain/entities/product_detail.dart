import 'package:equatable/equatable.dart';

import 'product_media.dart';
import 'product_summary.dart';

class ProductDetail extends Equatable {
  const ProductDetail({
    required this.summary,
    required this.description,
    required this.story,
    required this.mediaGallery,
    required this.highlights,
  });

  final ProductSummary summary;
  final String description;
  final String story;
  final List<ProductMedia> mediaGallery;
  final List<String> highlights;

  @override
  List<Object?> get props => <Object?>[
    summary,
    description,
    story,
    mediaGallery,
    highlights,
  ];
}
