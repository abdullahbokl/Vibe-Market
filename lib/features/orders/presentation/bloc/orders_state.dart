part of 'orders_bloc.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  const OrdersState({required this.status, required this.items, this.failure});

  factory OrdersState.initial() {
    return const OrdersState(
      status: OrdersStatus.initial,
      items: <OrderSummary>[],
    );
  }

  final OrdersStatus status;
  final List<OrderSummary> items;
  final Failure? failure;

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderSummary>? items,
    Failure? failure,
  }) {
    return OrdersState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, items, failure];
}
