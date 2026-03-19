part of 'search_bloc.dart';

EventTransformer<T> _debounceRestartable<T>(Duration duration) {
  return (events, mapper) => restartable<T>().call(
        events.debounceTime(duration),
        mapper,
      );
}

extension _SearchBlocHandlers on SearchBloc {
  Future<void> _onSearchStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    if (state.query.isNotEmpty || state.results.isNotEmpty) {
      return;
    }
    await _loadBrowsePage(emit, reset: true);
  }

  Future<void> _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) async => _loadBrowsePage(emit, reset: true);

  Future<void> _onSearchNextPageRequested(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (state.query.isNotEmpty ||
        state.status == SearchStatus.loading ||
        state.isPaginating ||
        state.hasReachedEnd) {
      return;
    }
    await _loadBrowsePage(emit, reset: false);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final String query = event.query.trim();
    if (query.isEmpty) {
      await _loadBrowsePage(emit, reset: true);
      return;
    }

    emit(_buildQueryLoadingState(query));
    final result = await _searchProducts(query);
    result.fold(
      (Failure failure) => emit(_buildFailureState(failure)),
      (List<ProductSummary> items) => emit(_buildQueryResultState(query, items)),
    );
  }

  Future<void> _loadBrowsePage(
    Emitter<SearchState> emit, {
    required bool reset,
  }) async {
    final int offset = reset ? 0 : state.results.length;
    emit(_buildBrowseLoadingState(reset));
    final result = await _browseProducts(offset: offset, limit: SearchBloc.pageSize);
    result.fold(
      (Failure failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          failure: failure,
          isPaginating: false,
        ),
      ),
      (List<ProductSummary> items) => emit(_buildBrowseResultState(reset, items)),
    );
  }

  SearchState _buildBrowseLoadingState(bool reset) {
    return state.copyWith(
      status: reset ? SearchStatus.loading : SearchStatus.success,
      query: '',
      failure: null,
      results: reset ? const <ProductSummary>[] : state.results,
      hasReachedEnd: reset ? false : state.hasReachedEnd,
      isPaginating: !reset,
    );
  }

  SearchState _buildBrowseResultState(bool reset, List<ProductSummary> items) {
    final List<ProductSummary> merged = reset
        ? items
        : <ProductSummary>[...state.results, ...items];
    return state.copyWith(
      status: merged.isEmpty ? SearchStatus.empty : SearchStatus.success,
      results: merged,
      failure: null,
      query: '',
      hasReachedEnd: items.length < SearchBloc.pageSize,
      isPaginating: false,
    );
  }

  SearchState _buildQueryLoadingState(String query) {
    return state.copyWith(
      status: SearchStatus.loading,
      query: query,
      results: const <ProductSummary>[],
      failure: null,
      hasReachedEnd: true,
      isPaginating: false,
    );
  }

  SearchState _buildFailureState(Failure failure) {
    return state.copyWith(
      status: SearchStatus.failure,
      failure: failure,
      hasReachedEnd: true,
      isPaginating: false,
    );
  }

  SearchState _buildQueryResultState(
    String query,
    List<ProductSummary> items,
  ) {
    return state.copyWith(
      status: items.isEmpty ? SearchStatus.empty : SearchStatus.success,
      results: items,
      failure: null,
      query: query,
      hasReachedEnd: true,
      isPaginating: false,
    );
  }
}
