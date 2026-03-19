import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../product/domain/entities/product_entities.dart';
import 'feed_product_card_item.dart';

class FeedPageView extends StatefulWidget {
  const FeedPageView({
    required this.products,
    required this.onOpenProduct,
    required this.onOpenSignIn,
    super.key,
  });

  final List<ProductSummary> products;
  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenSignIn;

  @override
  State<FeedPageView> createState() => _FeedPageViewState();
}

class _FeedPageViewState extends State<FeedPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefetchAround(0));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.products.length,
      onPageChanged: _prefetchAround,
      itemBuilder: (BuildContext context, int index) {
        final ProductSummary product = widget.products[index];
        return FeedProductCardItem(
          product: product,
          onOpenProduct: () => widget.onOpenProduct(product.id),
          onOpenSignIn: widget.onOpenSignIn,
        );
      },
    );
  }

  void _prefetchAround(int index) {
    _prefetchAt(index + 1);
    _prefetchAt(index - 1);
  }

  void _prefetchAt(int index) {
    if (!mounted || index < 0 || index >= widget.products.length) {
      return;
    }
    final ImageProvider imageProvider = CachedNetworkImageProvider(
      widget.products[index].heroImageUrl,
    );
    precacheImage(imageProvider, context);
  }
}
