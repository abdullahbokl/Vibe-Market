import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../domain/entities/product_entities.dart';

class ProductDetailGallery extends StatelessWidget {
  const ProductDetailGallery({required this.mediaGallery, super.key});

  final List<ProductMedia> mediaGallery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        itemCount: mediaGallery.length,
        itemBuilder: (BuildContext context, int index) {
          final ProductMedia media = mediaGallery[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MediaPreview(
              imageUrl: media.url,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          );
        },
      ),
    );
  }
}
