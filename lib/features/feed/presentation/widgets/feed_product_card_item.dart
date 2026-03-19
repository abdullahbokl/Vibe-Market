import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/dev_rebuild_logger.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import 'feed_product_card.dart';

class FeedProductCardItem extends StatelessWidget {
  const FeedProductCardItem({
    required this.product,
    required this.onOpenProduct,
    required this.onOpenSignIn,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onOpenProduct;
  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (WishlistState state) => state.ids.contains(product.id),
      builder: (BuildContext context, bool isWishlisted) {
        return DevRebuildLogger(
          label: 'feed-card:${product.id}',
          child: FeedProductCard(
            product: product,
            isWishlisted: isWishlisted,
            onOpenProduct: onOpenProduct,
            onToggleWishlist: () => _toggleWishlist(context),
          ),
        );
      },
    );
  }

  void _toggleWishlist(BuildContext context) {
    final AuthState authState = context.read<AuthCubit>().state;
    if (!authState.canAccessProtectedActions) {
      onOpenSignIn();
      return;
    }
    context.read<WishlistCubit>().toggle(
      productId: product.id,
      userScope: authState.userScope,
    );
  }
}
