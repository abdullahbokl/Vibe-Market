import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bootstrap_status.dart';
import '../cubit/bootstrap_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.onReady, super.key});

  final VoidCallback onReady;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BootstrapCubit>().bootstrap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BootstrapCubit, BootstrapState>(
      listenWhen: (BootstrapState previous, BootstrapState current) =>
          previous.status != current.status &&
          current.status == BootstrapStatus.ready,
      listener: (BuildContext ignoredContext, BootstrapState ignoredState) =>
          widget.onReady(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<BootstrapCubit, BootstrapState>(
            builder: (BuildContext context, BootstrapState state) {
              final String statusLabel = switch (state.status) {
                BootstrapStatus.initial => 'Preparing your next drop...',
                BootstrapStatus.loading =>
                  'Checking session, cache, and live availability...',
                BootstrapStatus.ready =>
                  state.isDemoMode
                      ? 'Launching in demo mode'
                      : 'Launching live storefront',
              };
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'VibeMarket',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      statusLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.isOnline
                          ? 'Network ready for live discovery.'
                          : 'No network detected. Cached discovery will still load.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
