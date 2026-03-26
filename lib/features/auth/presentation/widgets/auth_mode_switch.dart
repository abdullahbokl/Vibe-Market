import 'package:flutter/material.dart';
import 'auth_mode_button.dart';

class AuthModeSwitch extends StatelessWidget {
  const AuthModeSwitch({
    required this.isRegisterMode,
    required this.isBusy,
    required this.onModeChanged,
    super.key,
  });

  final bool isRegisterMode;
  final bool isBusy;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            AuthModeButton(
              label: 'Sign in',
              isSelected: !isRegisterMode,
              isBusy: isBusy,
              onTap: () => onModeChanged(false),
            ),
            const SizedBox(width: 8),
            AuthModeButton(
              label: 'Register',
              isSelected: isRegisterMode,
              isBusy: isBusy,
              onTap: () => onModeChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}
