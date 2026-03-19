import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product_entities.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  final ProductSummary product;
  final int quantity;

  int get lineTotalCents => product.priceCents * quantity;

  CartItem copyWith({ProductSummary? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => <Object?>[product, quantity];
}

class CartSnapshot extends Equatable {
  const CartSnapshot({required this.items});

  final List<CartItem> items;

  int get itemCount => items.fold<int>(0, (int sum, CartItem item) {
    return sum + item.quantity;
  });

  int get subtotalCents => items.fold<int>(0, (int sum, CartItem item) {
    return sum + item.lineTotalCents;
  });

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => <Object?>[items];
}
