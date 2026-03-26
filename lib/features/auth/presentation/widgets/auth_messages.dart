import 'package:flutter/material.dart';
import '../cubit/auth_cubit.dart';

class AuthMessages extends StatelessWidget {
  const AuthMessages({
    required this.state,
    super.key,
  });

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (state.failure != null) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            state.failure!.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
        if (state.statusMessage != null) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            state.statusMessage!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ],
    );
  }
}
