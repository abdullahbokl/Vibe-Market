import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/media_preview.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../cubit/wishlist_cubit.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({
    required this.onOpenProduct,
    required this.onOpenSignIn,
    super.key,
  });

  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    if (!context.watch<AuthCubit>().state.canAccessProtectedActions) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bookmarks')),
        body: AuthGateCard(
          title: 'Bookmarks are personal',
          message:
              'Sign in to keep saved drops synced to your profile and easy to revisit.',
          onPressed: onOpenSignIn,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (BuildContext context, WishlistState state) {
          if (state.ids.isEmpty) {
            return const EmptyStateView(
              title: 'No bookmarks yet',
              message:
                  'Tap the bookmark icon on any product to build your saved drop list.',
            );
          }
          return FutureBuilder(
            future: locator<ProductRepository>().getProductsByIds(
              state.ids.toList(),
            ),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final result = snapshot.data;
              if (result == null) {
                return const EmptyStateView(
                  title: 'Bookmarks unavailable',
                  message: 'Try again in a moment.',
                );
              }
              return result.fold(
                (failure) => Center(child: Text(failure.message)),
                (List<ProductSummary> products) => ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: <Widget>[
                    Text(
                      'Saved drops',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${products.length} products ready to revisit.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...products.map(
                      (ProductSummary product) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _BookmarkCard(
                          product: product,
                          onOpenProduct: () => onOpenProduct(product.id),
                          onRemove: () => context.read<WishlistCubit>().toggle(
                            productId: product.id,
                            userScope: context.read<AuthCubit>().state.userScope,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({
    required this.product,
    required this.onOpenProduct,
    required this.onRemove,
  });

  final ProductSummary product;
  final VoidCallback onOpenProduct;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onOpenProduct,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 92,
                height: 120,
                child: MediaPreview(
                  imageUrl: product.heroImageUrl,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  memCacheWidth: 184,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.seller.displayName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.tagline,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatPrice(
                        priceCents: product.priceCents,
                        currencyCode: product.currencyCode,
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.inventory.availableCount} left • ${product.dropMetadata.dropLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onOpenProduct,
                            child: const Text('View'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.bookmark),
                          tooltip: 'Remove bookmark',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
