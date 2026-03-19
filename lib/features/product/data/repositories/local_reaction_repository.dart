import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_cache_store.dart';
import '../../domain/entities/product_entities.dart';
import '../../domain/repositories/reaction_repository.dart';

class LocalReactionRepository implements ReactionRepository {
  LocalReactionRepository(this._cacheStore);

  final AppCacheStore _cacheStore;
  final Map<String, StreamController<Either<Failure, ReactionSnapshot>>>
  _controllers =
      <String, StreamController<Either<Failure, ReactionSnapshot>>>{};

  @override
  Future<Either<Failure, ReactionSnapshot>> getSnapshot(
    String productId,
  ) async {
    final Map<String, dynamic>? cached = _cacheStore.readJson(_key(productId));
    if (cached == null) {
      final ReactionSnapshot generated = _fallbackSnapshot(productId);
      await _persist(productId, generated);
      return right(generated);
    }
    return right(
      ReactionSnapshot(
        reactionCount: cached['reactionCount'] as int,
        liveViewerCount: cached['liveViewerCount'] as int,
        hasReacted: cached['hasReacted'] as bool,
      ),
    );
  }

  @override
  Future<Either<Failure, ReactionSnapshot>> toggleReaction(
    String productId,
  ) async {
    final Either<Failure, ReactionSnapshot> current = await getSnapshot(
      productId,
    );
    return current.fold(left, (ReactionSnapshot snapshot) async {
      final ReactionSnapshot updated = snapshot.copyWith(
        hasReacted: !snapshot.hasReacted,
        reactionCount: snapshot.hasReacted
            ? snapshot.reactionCount - 1
            : snapshot.reactionCount + 1,
      );
      await _persist(productId, updated);
      _controller(productId).add(right(updated));
      return right(updated);
    });
  }

  @override
  Stream<Either<Failure, ReactionSnapshot>> watchSnapshot(
    String productId,
  ) async* {
    yield await getSnapshot(productId);
    yield* _controller(productId).stream;
  }

  StreamController<Either<Failure, ReactionSnapshot>> _controller(
    String productId,
  ) {
    final StreamController<Either<Failure, ReactionSnapshot>>? existing =
        _controllers[productId];
    if (existing != null) {
      return existing;
    }
    final StreamController<Either<Failure, ReactionSnapshot>> controller =
        StreamController<Either<Failure, ReactionSnapshot>>.broadcast();
    _controllers[productId] = controller;
    return controller;
  }

  String _key(String productId) => 'reaction::$productId';

  ReactionSnapshot _fallbackSnapshot(String productId) {
    final int seed = productId.codeUnits.fold<int>(
      0,
      (int sum, int value) => sum + value,
    );
    return ReactionSnapshot(
      reactionCount: 80 + (seed % 500),
      liveViewerCount: 20 + (seed % 120),
      hasReacted: false,
    );
  }

  Future<void> _persist(String productId, ReactionSnapshot snapshot) {
    return _cacheStore.putJson(_key(productId), <String, dynamic>{
      'reactionCount': snapshot.reactionCount,
      'liveViewerCount': snapshot.liveViewerCount,
      'hasReacted': snapshot.hasReacted,
    });
  }
}
