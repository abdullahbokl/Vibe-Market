part of 'product_drop_bloc.dart';

enum ProductDropStatus { initial, loading, success, failure }

class ProductDropState extends Equatable {
  const ProductDropState({
    required this.status,
    this.product,
    this.reactionSnapshot,
    this.failure,
  });

  factory ProductDropState.initial() {
    return const ProductDropState(status: ProductDropStatus.initial);
  }

  final ProductDropStatus status;
  final ProductDetail? product;
  final ReactionSnapshot? reactionSnapshot;
  final Failure? failure;

  ProductDropState copyWith({
    ProductDropStatus? status,
    ProductDetail? product,
    ReactionSnapshot? reactionSnapshot,
    Failure? failure,
  }) {
    return ProductDropState(
      status: status ?? this.status,
      product: product ?? this.product,
      reactionSnapshot: reactionSnapshot ?? this.reactionSnapshot,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, product, reactionSnapshot, failure];
}
