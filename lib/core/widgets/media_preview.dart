import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'media_error_view.dart';
import 'media_placeholder.dart';

class MediaPreview extends StatelessWidget {
  const MediaPreview({
    required this.imageUrl,
    super.key,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
  });

  final String imageUrl;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final int? memCacheWidth;

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: _resolveMemCacheWidth(context),
      placeholder: (BuildContext context, String url) => const MediaPlaceholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          const MediaErrorView(),
    );
    final Widget content = height == null
        ? RepaintBoundary(child: image)
        : SizedBox(
            height: height,
            width: double.infinity,
            child: RepaintBoundary(child: image),
          );
    final BorderRadiusGeometry? radius = borderRadius;
    if (radius == null) {
      return content;
    }
    return ClipRRect(borderRadius: radius, child: content);
  }

  int? _resolveMemCacheWidth(BuildContext context) {
    if (memCacheWidth != null) {
      return memCacheWidth;
    }
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return (screenWidth * devicePixelRatio).round();
  }
}
