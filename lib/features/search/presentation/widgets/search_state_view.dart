import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/failure_state_view.dart';
import '../../../../core/widgets/performance_marker.dart';
import '../bloc/search_bloc.dart';
import 'search_results_list.dart';

class SearchStateView extends StatelessWidget {
  const SearchStateView({
    required this.scrollController,
    required this.onOpenProduct,
    super.key,
  });

  final ScrollController scrollController;
  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        final Widget child;
        switch (state.status) {
          case SearchStatus.initial:
            child = const EmptyStateView(
              title: 'Search the drop culture catalog',
              message: 'Try materials, product moods, seller names, or event-style phrases.',
            );
            break;
          case SearchStatus.loading:
            child = _buildLoading(state);
            break;
          case SearchStatus.failure:
            child = _buildFailure(state);
            break;
          case SearchStatus.empty:
            child = _buildEmpty(state.query);
            break;
          case SearchStatus.success:
            child = SearchResultsList(
              products: state.results,
              isPaginating: state.isPaginating,
              scrollController: scrollController,
              onOpenProduct: onOpenProduct,
            );
            break;
        }
        final bool shouldMarkPerformance =
            state.status == SearchStatus.success ||
            state.status == SearchStatus.empty ||
            state.status == SearchStatus.failure ||
            (state.status == SearchStatus.loading && state.results.isNotEmpty);

        if (shouldMarkPerformance) {
           return PerformanceMarker(
              traceKey: 'search.first-content',
              label: 'Search first content visible',
              child: child,
            );
        }
        return child;
      },
    );
  }

  Widget _buildLoading(SearchState state) {
    if (state.results.isNotEmpty) {
      return SearchResultsList(
        products: state.results,
        isPaginating: state.isPaginating,
        scrollController: scrollController,
        onOpenProduct: onOpenProduct,
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildFailure(SearchState state) {
    if (state.results.isNotEmpty) {
      return SearchResultsList(
        products: state.results,
        isPaginating: state.isPaginating,
        scrollController: scrollController,
        onOpenProduct: onOpenProduct,
      );
    }
    return FailureStateView(
      failure: state.failure ?? const Failure.unexpected('Search failed.'),
    );
  }

  Widget _buildEmpty(String query) {
    return EmptyStateView(
      title: query.isEmpty ? 'Catalog is still getting stocked' : 'No match yet',
      message: query.isEmpty
          ? 'Products will appear here automatically as the browse feed loads.'
          : 'Try broader language like outerwear, collectors, or flash capsule.',
    );
  }
}
