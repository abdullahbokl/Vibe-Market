import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/entities/cart_entities.dart';
import '../../domain/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(CartState.initial());

  final CartRepository _repository;

  Future<void> loadCart() async {
    final result = await _repository.loadCart();
    result.fold(
      (Failure failure) => emit(state.copyWith(failure: failure)),
      (CartSnapshot snapshot) =>
          emit(state.copyWith(snapshot: snapshot, failure: null)),
    );
  }

  Future<void> addProduct(ProductSummary product) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _repository.addItem(product: product);
    _applyResult(result);
  }

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _repository.updateItemQuantity(
      productId: productId,
      quantity: quantity,
    );
    _applyResult(result);
  }

  Future<void> removeItem(String productId) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _repository.removeItem(productId);
    _applyResult(result);
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _repository.clearCart();
    _applyResult(result);
  }

  void _applyResult(Either<Failure, CartSnapshot> result) {
    result.fold(
      (Failure failure) =>
          emit(state.copyWith(isBusy: false, failure: failure)),
      (CartSnapshot snapshot) => emit(
        state.copyWith(isBusy: false, snapshot: snapshot, failure: null),
      ),
    );
  }
}
