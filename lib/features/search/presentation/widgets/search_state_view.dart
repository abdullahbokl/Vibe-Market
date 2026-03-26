import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/performance_marker.dart';
import '../bloc/search_bloc.dart';
import 'search_empty_view.dart';
import 'search_failure_view.dart';
import 'search_loading_view.dart';
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
            child = SearchLoadingView(
              state: state,
              scrollController: scrollController,
              onOpenProduct: onOpenProduct,
            );
            break;
          case SearchStatus.failure:
            child = SearchFailureView(
              state: state,
              scrollController: scrollController,
              onOpenProduct: onOpenProduct,
            );
            break;
          case SearchStatus.empty:
            child = SearchEmptyView(query: state.query);
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
}
