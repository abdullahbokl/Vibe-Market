part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, empty, failure }

class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.query,
    required this.results,
    required this.hasReachedEnd,
    required this.isPaginating,
    this.failure,
  });

  factory SearchState.initial() {
    return const SearchState(
      status: SearchStatus.initial,
      query: '',
      results: <ProductSummary>[],
      hasReachedEnd: false,
      isPaginating: false,
    );
  }

  final SearchStatus status;
  final String query;
  final List<ProductSummary> results;
  final bool hasReachedEnd;
  final bool isPaginating;
  final Failure? failure;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<ProductSummary>? results,
    bool? hasReachedEnd,
    bool? isPaginating,
    Failure? failure,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isPaginating: isPaginating ?? this.isPaginating,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    query,
    results,
    hasReachedEnd,
    isPaginating,
    failure,
  ];
}
