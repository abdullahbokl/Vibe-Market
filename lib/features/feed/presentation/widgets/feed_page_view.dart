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
  late final PageController _pageController;
  int _lastPrefetchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefetchAround(0));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    
    // In continuous scroll, we want to prefetch when a new item is approaching the screen
    final double pageOffset = _pageController.page ?? 0;
    final int approachingIndex = pageOffset.round();
    
    if (approachingIndex != _lastPrefetchedIndex) {
      _lastPrefetchedIndex = approachingIndex;
      _prefetchAround(approachingIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      pageSnapping: false,
      allowImplicitScrolling: true,
      scrollDirection: Axis.vertical,
      // Bouncing physics feels smoother for continuous social feeds
      physics: const BouncingScrollPhysics(),
      itemCount: widget.products.length,
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
    // Proactively fetch 2 items ahead for fluid continuous scroll
    for (int i = 1; i <= 2; i++) {
        _prefetchAt(index + i);
    }
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
