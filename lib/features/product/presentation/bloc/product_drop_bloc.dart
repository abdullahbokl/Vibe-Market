import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entities.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/reaction_repository.dart';

part 'product_drop_event.dart';
part 'product_drop_state.dart';

class ProductDropBloc extends Bloc<ProductDropEvent, ProductDropState> {
  ProductDropBloc({
    required ProductRepository productRepository,
    required ReactionRepository reactionRepository,
  }) : _productRepository = productRepository,
       _reactionRepository = reactionRepository,
       super(ProductDropState.initial()) {
    on<ProductDropStarted>(_onStarted);
    on<ProductReactionToggled>(_onReactionToggled);
    on<ProductReactionSnapshotUpdated>(_onReactionSnapshotUpdated);
  }

  final ProductRepository _productRepository;
  final ReactionRepository _reactionRepository;

  StreamSubscription? _reactionSubscription;

  Future<void> _onStarted(
    ProductDropStarted event,
    Emitter<ProductDropState> emit,
  ) async {
    emit(state.copyWith(status: ProductDropStatus.loading, failure: null));

    final results = await Future.wait([
      _productRepository.getProductById(event.productId),
      _reactionRepository.getSnapshot(event.productId),
    ]);

    final detailResult = results[0] as Either<Failure, ProductDetail>;
    final reactionResult = results[1] as Either<Failure, ReactionSnapshot>;

    detailResult.fold(
      (Failure failure) => emit(
        state.copyWith(status: ProductDropStatus.failure, failure: failure),
      ),
      (ProductDetail product) {
        final ReactionSnapshot reactionSnapshot = reactionResult.fold(
          (_) => product.summary.reactionSnapshot,
          (ReactionSnapshot snapshot) => snapshot,
        );
        emit(
          state.copyWith(
            status: ProductDropStatus.success,
            product: product,
            reactionSnapshot: reactionSnapshot,
            failure: null,
          ),
        );
      },
    );

    await _reactionSubscription?.cancel();
    _reactionSubscription = _reactionRepository
        .watchSnapshot(event.productId)
        .listen((result) {
          result.fold(
            (_) {},
            (ReactionSnapshot snapshot) =>
                add(ProductReactionSnapshotUpdated(snapshot)),
          );
        });
  }

  Future<void> _onReactionToggled(
    ProductReactionToggled event,
    Emitter<ProductDropState> emit,
  ) async {
    final ProductDetail? product = state.product;
    if (product == null) {
      return;
    }
    await _reactionRepository.toggleReaction(product.summary.id);
  }

  void _onReactionSnapshotUpdated(
    ProductReactionSnapshotUpdated event,
    Emitter<ProductDropState> emit,
  ) {
    emit(state.copyWith(reactionSnapshot: event.snapshot));
  }

  @override
  Future<void> close() async {
    await _reactionSubscription?.cancel();
    return super.close();
  }
}
