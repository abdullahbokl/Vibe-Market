import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_cache_store.dart';
import '../../../product/data/models/product_serializers.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/entities/cart_entities.dart';
import '../../domain/repositories/cart_repository.dart';

class PersistentCartRepository implements CartRepository {
  PersistentCartRepository(this._cacheStore);

  final AppCacheStore _cacheStore;
  static const String _cartKey = 'cart::snapshot';

  @override
  Future<Either<Failure, CartSnapshot>> addItem({
    required ProductSummary product,
    int quantity = 1,
  }) async {
    final CartSnapshot cart = await _readCart();
    final List<CartItem> updated = List<CartItem>.from(cart.items);
    final int existingIndex = updated.indexWhere(
      (CartItem item) => item.product.id == product.id,
    );
    if (existingIndex == -1) {
      updated.add(CartItem(product: product, quantity: quantity));
    } else {
      final CartItem existing = updated[existingIndex];
      updated[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    }
    return _persist(updated);
  }

  @override
  Future<Either<Failure, CartSnapshot>> clearCart() {
    return _persist(const <CartItem>[]);
  }

  @override
  Future<Either<Failure, CartSnapshot>> loadCart() async {
    return right(await _readCart());
  }

  @override
  Future<Either<Failure, CartSnapshot>> removeItem(String productId) async {
    final CartSnapshot cart = await _readCart();
    final List<CartItem> updated = cart.items
        .where((CartItem item) => item.product.id != productId)
        .toList();
    return _persist(updated);
  }

  @override
  Future<Either<Failure, CartSnapshot>> updateItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    final CartSnapshot cart = await _readCart();
    final List<CartItem> updated = <CartItem>[];
    for (final CartItem item in cart.items) {
      if (item.product.id != productId) {
        updated.add(item);
        continue;
      }
      if (quantity > 0) {
        updated.add(item.copyWith(quantity: quantity));
      }
    }
    return _persist(updated);
  }

  Future<CartSnapshot> _readCart() async {
    final List<Map<String, dynamic>> items = _cacheStore.readJsonList(_cartKey);
    return CartSnapshot(items: items.map(_cartItemFromMap).toList());
  }

  Future<Either<Failure, CartSnapshot>> _persist(List<CartItem> items) async {
    await _cacheStore.putJsonList(_cartKey, items.map(_cartItemToMap).toList());
    return right(CartSnapshot(items: items));
  }

  Map<String, dynamic> _cartItemToMap(CartItem item) {
    return <String, dynamic>{
      'product': ProductSerializers.summaryToMap(item.product),
      'quantity': item.quantity,
    };
  }

  CartItem _cartItemFromMap(Map<String, dynamic> json) {
    return CartItem(
      product: ProductSerializers.summaryFromMap(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      quantity: json['quantity'] as int,
    );
  }
}
