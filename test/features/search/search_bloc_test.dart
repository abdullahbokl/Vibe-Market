import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vibemarket/core/error/failure.dart';
import 'package:vibemarket/features/product/domain/entities/product_entities.dart';
import 'package:vibemarket/features/search/domain/repositories/search_repository.dart';
import 'package:vibemarket/features/search/domain/usecases/browse_products.dart';
import 'package:vibemarket/features/search/domain/usecases/search_products.dart';
import 'package:vibemarket/features/search/presentation/bloc/search_bloc.dart';

class _MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late _MockSearchRepository repository;
  late ProductSummary product;

  setUp(() {
    repository = _MockSearchRepository();
    product = ProductSummary(
      id: 'sample',
      title: 'Obsidian Runner Jacket',
      tagline: 'Light-reactive shell',
      priceCents: 24800,
      currencyCode: 'USD',
      heroImageUrl: 'https://example.com/jacket.png',
      seller: const SellerSummary(
        id: 'seller_1',
        handle: '@novalab',
        displayName: 'Nova Lab',
      ),
      inventory: const InventorySnapshot(
        availableCount: 14,
        totalCount: 60,
        isLowStock: true,
      ),
      dropMetadata: DropMetadata(
        saleEndTime: DateTime.utc(2030, 1, 1),
        dropLabel: 'After Hours Drop',
      ),
      reactionSnapshot: const ReactionSnapshot(
        reactionCount: 482,
        liveViewerCount: 126,
        hasReacted: false,
      ),
      tags: const <String>['outerwear'],
    );
  });

  blocTest<SearchBloc, SearchState>(
    'emits loading then success for matching query',
    build: () {
      when(
        () => repository.searchProducts('jacket'),
      ).thenAnswer((_) async => right(<ProductSummary>[product]));
      return SearchBloc(SearchProducts(repository), BrowseProducts(repository));
    },
    act: (SearchBloc bloc) => bloc.add(const SearchQueryChanged('jacket')),
    wait: const Duration(milliseconds: 400),
    expect: () => <SearchState>[
      SearchState.initial().copyWith(
        status: SearchStatus.loading,
        query: 'jacket',
        hasReachedEnd: true,
      ),
      SearchState.initial().copyWith(
        status: SearchStatus.success,
        query: 'jacket',
        results: <ProductSummary>[product],
        hasReachedEnd: true,
      ),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits failure when repository fails',
    build: () {
      when(() => repository.searchProducts('broken')).thenAnswer(
        (_) async => const Left<Failure, List<ProductSummary>>(
          Failure.unexpected('Search failed'),
        ),
      );
      return SearchBloc(SearchProducts(repository), BrowseProducts(repository));
    },
    act: (SearchBloc bloc) => bloc.add(const SearchQueryChanged('broken')),
    wait: const Duration(milliseconds: 400),
    expect: () => <SearchState>[
      SearchState.initial().copyWith(
        status: SearchStatus.loading,
        query: 'broken',
        hasReachedEnd: true,
      ),
      SearchState.initial().copyWith(
        status: SearchStatus.failure,
        query: 'broken',
        failure: const Failure.unexpected('Search failed'),
        hasReachedEnd: true,
      ),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'loads the first browse page when search starts with an empty query',
    build: () {
      when(
        () => repository.browseProducts(offset: 0, limit: 16),
      ).thenAnswer((_) async => right(<ProductSummary>[product]));
      return SearchBloc(SearchProducts(repository), BrowseProducts(repository));
    },
    act: (SearchBloc bloc) => bloc.add(const SearchStarted()),
    expect: () => <SearchState>[
      SearchState.initial().copyWith(
        status: SearchStatus.loading,
        query: '',
        results: const <ProductSummary>[],
        hasReachedEnd: false,
        isPaginating: false,
      ),
      SearchState.initial().copyWith(
        status: SearchStatus.success,
        query: '',
        results: <ProductSummary>[product],
        hasReachedEnd: true,
        isPaginating: false,
      ),
    ],
  );
}
