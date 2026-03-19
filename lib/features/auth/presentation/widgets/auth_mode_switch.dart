import 'package:flutter/material.dart';

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
            _ModeButton(
              label: 'Sign in',
              isSelected: !isRegisterMode,
              isBusy: isBusy,
              onTap: () => onModeChanged(false),
            ),
            const SizedBox(width: 8),
            _ModeButton(
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

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.isBusy,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton.tonal(
        onPressed: isBusy ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: isSelected ? null : Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(label),
      ),
    );
  }
}
