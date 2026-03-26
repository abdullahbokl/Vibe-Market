import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widgets/auth_gate_card.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/failure_state_view.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../bloc/orders_bloc.dart';
import '../widgets/order_tile.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({required this.onOpenSignIn, super.key});

  final VoidCallback onOpenSignIn;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (AuthState state) => state.canAccessProtectedActions,
      builder: (BuildContext context, bool canAccess) {
        if (!canAccess) {
          return Scaffold(
            appBar: AppBar(title: const Text('Orders')),
            body: AuthGateCard(
              title: 'Orders are tied to your account',
              message:
                  'Sign in to view paid orders, status changes, and warehouse notifications.',
              onPressed: onOpenSignIn,
            ),
          );
        }

        return BlocProvider<OrdersBloc>(
          create: (_) => locator<OrdersBloc>()..add(const OrdersWatchStarted()),
          child: Scaffold(
            appBar: AppBar(title: const Text('Orders')),
            body: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (BuildContext context, OrdersState state) {
                switch (state.status) {
                  case OrdersStatus.initial:
                  case OrdersStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case OrdersStatus.failure:
                    return FailureStateView(
                      failure:
                          state.failure ??
                          const Failure.unexpected('Orders could not be loaded.'),
                    );
                  case OrdersStatus.success:
                    if (state.items.isEmpty) {
                      return const EmptyStateView(
                        title: 'No orders yet',
                        message:
                            'Your paid orders will appear here with live status updates.',
                      );
                    }
                    return ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder:
                          (BuildContext ignoredContext, int ignoredIndex) =>
                              const Divider(height: 1),
                      itemBuilder: (BuildContext context, int index) {
                        return RepaintBoundary(
                          child: OrderTile(order: state.items[index]),
                        );
                      },
                    );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
