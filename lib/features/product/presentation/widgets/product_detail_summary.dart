import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/countdown_ticker.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/countdown_pill.dart';
import '../../../../core/widgets/dev_rebuild_logger.dart';
import '../../../../core/widgets/price_badge.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/product_entities.dart';
import '../bloc/product_drop_bloc.dart';

class ProductDetailSummary extends StatelessWidget {
  const ProductDetailSummary({
    required this.product,
    required this.onOpenSignIn,
    super.key,
  });

  final ProductDetail product;
  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    final ProductSummary summary = product.summary;
    final DateTime? saleEndTime = summary.dropMetadata.saleEndTime;
    final String priceLabel = formatPrice(
      priceCents: summary.priceCents,
      currencyCode: summary.currencyCode,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(summary.title, style: Theme.of(context).textTheme.headlineMedium),
            ),
            BlocSelector<WishlistCubit, WishlistState, bool>(
              selector: (WishlistState state) => state.ids.contains(summary.id),
              builder: (BuildContext context, bool isWishlisted) {
                return DevRebuildLogger(
                  label: 'product-detail:bookmark:${summary.id}',
                  child: IconButton(
                    onPressed: () => _toggleWishlist(context),
                    icon: Icon(
                      isWishlisted
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(summary.tagline),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            PriceBadge(label: priceLabel),
            if (saleEndTime != null) ...<Widget>[
              const SizedBox(width: 12),
              CountdownPill(
                endTime: saleEndTime,
                precision: CountdownPrecision.seconds,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Text(product.description),
        const SizedBox(height: 12),
        Text('Inventory: ${summary.inventory.availableCount} left'),
        BlocSelector<ProductDropBloc, ProductDropState, ReactionSnapshot>(
          selector: (ProductDropState state) =>
              state.reactionSnapshot ?? summary.reactionSnapshot,
          builder: (BuildContext context, ReactionSnapshot reactionSnapshot) {
            return DevRebuildLogger(
              label: 'product-detail:reaction:${summary.id}',
              child: Text(
                '${reactionSnapshot.reactionCount} reactions • '
                '${reactionSnapshot.liveViewerCount} live viewers',
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Drop Story', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(product.story),
      ],
    );
  }

  void _toggleWishlist(BuildContext context) {
    final AuthState authState = context.read<AuthCubit>().state;
    if (!authState.canAccessProtectedActions) {
      onOpenSignIn();
      return;
    }
    context.read<WishlistCubit>().toggle(
      productId: product.summary.id,
      userScope: authState.userScope,
    );
  }
}
