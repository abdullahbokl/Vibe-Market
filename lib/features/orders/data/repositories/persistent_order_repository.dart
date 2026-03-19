import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_cache_store.dart';
import '../../domain/entities/order_entities.dart';
import '../../domain/repositories/order_repository.dart';

class PersistentOrderRepository implements OrderRepository {
  PersistentOrderRepository(this._cacheStore);

  static const String _orderKey = 'orders::history';

  final AppCacheStore _cacheStore;
  final StreamController<Either<Failure, List<OrderSummary>>> _controller =
      StreamController<Either<Failure, List<OrderSummary>>>.broadcast();

  @override
  Future<Either<Failure, List<OrderSummary>>> loadOrders() async {
    return right(_readOrders());
  }

  @override
  Stream<Either<Failure, List<OrderSummary>>> watchOrders() async* {
    yield right(_readOrders());
    yield* _controller.stream;
  }

  Future<void> appendOrder(OrderSummary order) async {
    final List<OrderSummary> orders = _readOrders();
    final List<OrderSummary> updated = <OrderSummary>[order, ...orders];
    await _cacheStore.putJsonList(_orderKey, updated.map(_orderToMap).toList());
    _controller.add(right(updated));
  }

  List<OrderSummary> _readOrders() {
    final List<Map<String, dynamic>> items = _cacheStore.readJsonList(
      _orderKey,
    );
    return items.map(_orderFromMap).toList();
  }

  Map<String, dynamic> _orderToMap(OrderSummary order) {
    return <String, dynamic>{
      'id': order.id,
      'title': order.title,
      'amountCents': order.amountCents,
      'currencyCode': order.currencyCode,
      'status': order.status,
      'createdAt': order.createdAt.toIso8601String(),
    };
  }

  OrderSummary _orderFromMap(Map<String, dynamic> json) {
    return OrderSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      amountCents: json['amountCents'] as int,
      currencyCode: json['currencyCode'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
