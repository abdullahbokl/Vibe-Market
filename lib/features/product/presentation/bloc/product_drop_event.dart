part of 'product_drop_bloc.dart';

sealed class ProductDropEvent extends Equatable {
  const ProductDropEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ProductDropStarted extends ProductDropEvent {
  const ProductDropStarted(this.productId);

  final String productId;

  @override
  List<Object?> get props => <Object?>[productId];
}

class ProductReactionToggled extends ProductDropEvent {
  const ProductReactionToggled();
}

class ProductReactionSnapshotUpdated extends ProductDropEvent {
  const ProductReactionSnapshotUpdated(this.snapshot);

  final ReactionSnapshot snapshot;

  @override
  List<Object?> get props => <Object?>[snapshot];
}
