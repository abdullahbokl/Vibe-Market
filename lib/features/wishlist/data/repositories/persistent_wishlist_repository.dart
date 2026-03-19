import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/storage/app_cache_store.dart';
import '../../domain/repositories/wishlist_repository.dart';

class PersistentWishlistRepository implements WishlistRepository {
  PersistentWishlistRepository(this._cacheStore);

  final AppCacheStore _cacheStore;

  @override
  Future<Either<Failure, Set<String>>> loadWishlistIds() async {
    final String? rawValue = _cacheStore.readString(_key('active'));
    if (rawValue == null || rawValue.isEmpty) {
      return const Right<Failure, Set<String>>(<String>{});
    }
    final Object? decoded = jsonDecode(rawValue);
    if (decoded is List<dynamic>) {
      return right(decoded.whereType<String>().toSet());
    }
    return const Right<Failure, Set<String>>(<String>{});
  }

  @override
  Future<Either<Failure, Set<String>>> toggleWishlist({
    required String productId,
    required String userScope,
  }) async {
    if (!userScope.startsWith('user-')) {
      return const Left<Failure, Set<String>>(
        Failure.validation('Sign in to save items to your wishlist.'),
      );
    }

    final Either<Failure, Set<String>> current = await loadWishlistIds();
    return current.fold(left, (Set<String> ids) async {
      final Set<String> updated = Set<String>.from(ids);
      if (updated.contains(productId)) {
        updated.remove(productId);
      } else {
        updated.add(productId);
      }
      await _cacheStore.putString(_key('active'), jsonEncode(updated.toList()));
      return right(updated);
    });
  }

  String _key(String scope) => 'wishlist::$scope';
}
