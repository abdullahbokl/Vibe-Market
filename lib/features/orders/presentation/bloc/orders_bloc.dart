import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/order_entities.dart';
import '../../domain/repositories/order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this._repository) : super(OrdersState.initial()) {
    on<OrdersWatchStarted>(_onStarted);
    on<OrdersUpdated>(_onUpdated);
    on<OrdersFailed>(_onFailed);
  }

  final OrderRepository _repository;
  StreamSubscription? _subscription;

  Future<void> _onStarted(
    OrdersWatchStarted event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading, failure: null));
    await _subscription?.cancel();
    _subscription = _repository.watchOrders().listen((result) {
      result.fold(
        (Failure failure) => add(OrdersFailed(failure)),
        (List<OrderSummary> orders) => add(OrdersUpdated(orders)),
      );
    });
  }

  void _onUpdated(OrdersUpdated event, Emitter<OrdersState> emit) {
    emit(
      state.copyWith(
        status: OrdersStatus.success,
        items: event.items,
        failure: null,
      ),
    );
  }

  void _onFailed(OrdersFailed event, Emitter<OrdersState> emit) {
    emit(state.copyWith(status: OrdersStatus.failure, failure: event.failure));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
