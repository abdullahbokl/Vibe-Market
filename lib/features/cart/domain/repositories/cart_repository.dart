import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../entities/cart_entities.dart';

abstract class CartRepository {
  Future<Either<Failure, CartSnapshot>> loadCart();

  Future<Either<Failure, CartSnapshot>> addItem({
    required ProductSummary product,
    int quantity = 1,
  });

  Future<Either<Failure, CartSnapshot>> updateItemQuantity({
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, CartSnapshot>> removeItem(String productId);

  Future<Either<Failure, CartSnapshot>> clearCart();
}
