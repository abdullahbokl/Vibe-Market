import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/performance/performance_trace.dart';
import '../../../../core/widgets/failure_state_view.dart';
import '../../../../core/widgets/loading_state_view.dart';
import '../../../../core/widgets/performance_marker.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/feed_page_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({
    required this.onOpenProduct,
    required this.onOpenSignIn,
    super.key,
  });

  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    PerformanceTrace.start('feed.first-content');
    return BlocProvider<FeedBloc>(
      create: (_) => locator<FeedBloc>()..add(const FeedRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Live Feed')),
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (BuildContext context, FeedState state) {
            switch (state.status) {
              case FeedStatus.initial:
              case FeedStatus.loading:
                return const LoadingStateView();
              case FeedStatus.failure:
                return FailureStateView(
                  failure:
                      state.failure ??
                      const Failure.unexpected('Feed could not be loaded.'),
                  onRetry: () =>
                      context.read<FeedBloc>().add(const FeedRequested()),
                );
              case FeedStatus.success:
                return PerformanceMarker(
                  traceKey: 'feed.first-content',
                  label: 'Feed first content visible',
                  child: FeedPageView(
                    products: state.items,
                    onOpenProduct: onOpenProduct,
                    onOpenSignIn: onOpenSignIn,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
