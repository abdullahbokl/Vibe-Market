part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class OrdersWatchStarted extends OrdersEvent {
  const OrdersWatchStarted();
}

class OrdersUpdated extends OrdersEvent {
  const OrdersUpdated(this.items);

  final List<OrderSummary> items;

  @override
  List<Object?> get props => <Object?>[items];
}

class OrdersFailed extends OrdersEvent {
  const OrdersFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => <Object?>[failure];
}
