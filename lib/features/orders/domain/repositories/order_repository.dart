import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/order_entities.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderSummary>>> loadOrders();

  Stream<Either<Failure, List<OrderSummary>>> watchOrders();
}
