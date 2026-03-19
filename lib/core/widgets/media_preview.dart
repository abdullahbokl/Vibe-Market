import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme_palette.dart';

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
      placeholder: _buildPlaceholder,
      errorWidget: _buildErrorWidget,
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

  Widget _buildPlaceholder(BuildContext context, String url) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return ColoredBox(
      color: palette.elevatedSurface,
      child: const SizedBox.expand(),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, Object error) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return ColoredBox(
      color: palette.elevatedSurface,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
