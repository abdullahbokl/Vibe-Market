import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../domain/entities/product_entities.dart';

class ProductDetailGallery extends StatefulWidget {
  const ProductDetailGallery({required this.mediaGallery, super.key});

  final List<ProductMedia> mediaGallery;

  @override
  State<ProductDetailGallery> createState() => _ProductDetailGalleryState();
}

class _ProductDetailGalleryState extends State<ProductDetailGallery> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefetchAround(0));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        itemCount: widget.mediaGallery.length,
        onPageChanged: _prefetchAround,
        itemBuilder: (BuildContext context, int index) {
          final ProductMedia media = widget.mediaGallery[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MediaPreview(
              imageUrl: media.url,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              memCacheWidth: 720,
            ),
          );
        },
      ),
    );
  }

  void _prefetchAround(int index) {
    _prefetchAt(index + 1);
    _prefetchAt(index - 1);
  }

  void _prefetchAt(int index) {
    if (!mounted || index < 0 || index >= widget.mediaGallery.length) {
      return;
    }
    final ImageProvider imageProvider = CachedNetworkImageProvider(
      widget.mediaGallery[index].url,
    );
    precacheImage(imageProvider, context);
  }
}
