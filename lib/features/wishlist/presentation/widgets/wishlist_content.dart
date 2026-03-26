import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../cubit/wishlist_cubit.dart';
import 'wishlist_item_card.dart';

class WishlistContent extends StatelessWidget {
  const WishlistContent({
    required this.ids,
    required this.onOpenProduct,
    super.key,
  });

  final Set<String> ids;
  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<ProductRepository>().getProductsByIds(
        ids.toList(),
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
                  child: WishlistItemCard(
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
  }
}
