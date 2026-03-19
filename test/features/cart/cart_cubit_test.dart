import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemarket/core/error/failure.dart';
import 'package:vibemarket/features/cart/domain/entities/cart_entities.dart';
import 'package:vibemarket/features/cart/domain/repositories/cart_repository.dart';
import 'package:vibemarket/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:vibemarket/features/product/domain/entities/product_entities.dart';

class _FakeCartRepository implements CartRepository {
  CartSnapshot _snapshot = const CartSnapshot(items: <CartItem>[]);

  @override
  Future<Either<Failure, CartSnapshot>> addItem({
    required ProductSummary product,
    int quantity = 1,
  }) async {
    _snapshot = CartSnapshot(
      items: <CartItem>[
        ..._snapshot.items,
        CartItem(product: product, quantity: quantity),
      ],
    );
    return right(_snapshot);
  }

  @override
  Future<Either<Failure, CartSnapshot>> clearCart() async {
    _snapshot = const CartSnapshot(items: <CartItem>[]);
    return right(_snapshot);
  }

  @override
  Future<Either<Failure, CartSnapshot>> loadCart() async {
    return right(_snapshot);
  }

  @override
  Future<Either<Failure, CartSnapshot>> removeItem(String productId) async {
    _snapshot = CartSnapshot(
      items: _snapshot.items
          .where((CartItem item) => item.product.id != productId)
          .toList(),
    );
    return right(_snapshot);
  }

  @override
  Future<Either<Failure, CartSnapshot>> updateItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    _snapshot = CartSnapshot(
      items: _snapshot.items.map((CartItem item) {
        if (item.product.id != productId) {
          return item;
        }
        return item.copyWith(quantity: quantity);
      }).toList(),
    );
    return right(_snapshot);
  }
}

void main() {
  final sampleProduct = ProductSummary(
    id: 'sample',
    title: 'Sample Drop',
    tagline: 'Premium sample',
    priceCents: 12000,
    currencyCode: 'USD',
    heroImageUrl: 'https://example.com/image.png',
    seller: const SellerSummary(
      id: 'seller_1',
      handle: '@seller',
      displayName: 'Seller',
    ),
    inventory: const InventorySnapshot(
      availableCount: 12,
      totalCount: 40,
      isLowStock: true,
    ),
    dropMetadata: DropMetadata(
      saleEndTime: DateTime.utc(2030, 1, 1),
      dropLabel: 'Future Drop',
    ),
    reactionSnapshot: const ReactionSnapshot(
      reactionCount: 20,
      liveViewerCount: 12,
      hasReacted: false,
    ),
    tags: const <String>['sample'],
  );

  blocTest<CartCubit, CartState>(
    'adds a product and updates snapshot totals',
    build: () => CartCubit(_FakeCartRepository()),
    act: (CartCubit cubit) => cubit.addProduct(sampleProduct),
    expect: () => <CartState>[
      CartState.initial().copyWith(isBusy: true),
      CartState.initial().copyWith(
        isBusy: false,
        snapshot: CartSnapshot(
          items: <CartItem>[CartItem(product: sampleProduct, quantity: 1)],
        ),
      ),
    ],
  );
}
