import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../bloc/product_drop_bloc.dart';
import '../../domain/entities/product_entities.dart';

class ProductDetailActions extends StatelessWidget {
  const ProductDetailActions({
    required this.product,
    required this.onOpenSignIn,
    required this.onOpenCheckout,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _handleGuarded(context, () {
            context.read<CartCubit>().addProduct(product);
            onOpenCheckout();
          }),
          child: const Text('Buy now'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _handleGuarded(context, () {
            context.read<CartCubit>().addProduct(product);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Added to cart')));
          }),
          child: const Text('Add to cart'),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => _handleGuarded(
            context,
            () => context.read<ProductDropBloc>().add(const ProductReactionToggled()),
          ),
          icon: const Icon(Icons.favorite_border),
          label: const Text('React to this drop'),
        ),
      ],
    );
  }

  void _handleGuarded(BuildContext context, VoidCallback action) {
    if (!context.read<AuthCubit>().state.canAccessProtectedActions) {
      onOpenSignIn();
      return;
    }
    action();
  }
}
