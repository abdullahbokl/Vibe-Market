part of 'cart_cubit.dart';

class CartState extends Equatable {
  const CartState({required this.snapshot, required this.isBusy, this.failure});

  factory CartState.initial() {
    return const CartState(
      snapshot: CartSnapshot(items: <CartItem>[]),
      isBusy: false,
    );
  }

  final CartSnapshot snapshot;
  final bool isBusy;
  final Failure? failure;

  CartState copyWith({CartSnapshot? snapshot, bool? isBusy, Failure? failure}) {
    return CartState(
      snapshot: snapshot ?? this.snapshot,
      isBusy: isBusy ?? this.isBusy,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[snapshot, isBusy, failure];
}
