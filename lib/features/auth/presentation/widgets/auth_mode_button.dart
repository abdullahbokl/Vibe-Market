import 'package:flutter/material.dart';

class AuthModeButton extends StatelessWidget {
  const AuthModeButton({
    required this.label,
    required this.isSelected,
    required this.isBusy,
    required this.onTap,
    super.key,
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
