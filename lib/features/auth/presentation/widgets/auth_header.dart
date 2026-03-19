import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.isRegisterMode, super.key});

  final bool isRegisterMode;

  @override
  Widget build(BuildContext context) {
    final String title = isRegisterMode ? 'Create account' : 'Sign in';
    final String subtitle = isRegisterMode
        ? 'Create your buyer account to save wishlists, react, and check out faster.'
        : 'Unlock reactions, cart, checkout, and order history.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
