import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/performance/performance_trace.dart';
import '../../../../core/widgets/performance_marker.dart';
import '../../../../core/widgets/failure_state_view.dart';
import '../../../../core/widgets/loading_state_view.dart';
import '../bloc/product_drop_bloc.dart';
import '../widgets/product_detail_content.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    required this.productId,
    required this.onOpenSignIn,
    required this.onOpenCheckout,
    super.key,
  });

  final String productId;
  final VoidCallback onOpenSignIn;
  final VoidCallback onOpenCheckout;

  @override
  Widget build(BuildContext context) {
    final String traceKey = 'product-detail:$productId:first-content';
    PerformanceTrace.start(traceKey);
    return BlocProvider<ProductDropBloc>(
      create: (_) => locator<ProductDropBloc>()..add(ProductDropStarted(productId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Detail')),
        body: BlocBuilder<ProductDropBloc, ProductDropState>(
          buildWhen: (ProductDropState previous, ProductDropState current) {
            return previous.status != current.status ||
                previous.product != current.product ||
                previous.failure != current.failure;
          },
          builder: (BuildContext context, ProductDropState state) {
            switch (state.status) {
              case ProductDropStatus.initial:
              case ProductDropStatus.loading:
                return const LoadingStateView();
              case ProductDropStatus.failure:
                return FailureStateView(
                  failure: state.failure ??
                      const Failure.unexpected('Product detail failed to load.'),
                );
              case ProductDropStatus.success:
                final product = state.product;
                if (product == null) {
                  return const FailureStateView(
                    failure: Failure.notFound('This product is unavailable.'),
                  );
                }
                return PerformanceMarker(
                  traceKey: traceKey,
                  label: 'Product detail first content visible',
                  child: ProductDetailContent(
                    product: product,
                    onOpenSignIn: onOpenSignIn,
                    onOpenCheckout: onOpenCheckout,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
