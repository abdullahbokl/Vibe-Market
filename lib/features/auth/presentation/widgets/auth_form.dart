import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/services/snackbar_service.dart';
import '../cubit/auth_cubit.dart';
import 'auth_messages.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    required this.state,
    required this.isRegisterMode,
    required this.displayNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    super.key,
  });

  final AuthState state;
  final bool isRegisterMode;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (isRegisterMode) ...<Widget>[
          const SizedBox(height: 20),
          TextField(
            controller: displayNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Display name'),
          ),
        ],
        const SizedBox(height: 20),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: true,
          textInputAction: isRegisterMode ? TextInputAction.next : TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        if (isRegisterMode) ...<Widget>[
          const SizedBox(height: 12),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Confirm password'),
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state.isBusy ? null : () => _submit(context),
          child: Text(
            isRegisterMode ? 'Create account with email' : 'Sign in with email',
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: state.isBusy ? null : () => context.read<AuthCubit>().signInWithGoogle(),
          child: Text(isRegisterMode ? 'Register with Google' : 'Sign in with Google'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: state.isBusy ? null : () => context.read<AuthCubit>().continueAsGuest(),
          child: const Text('Continue as guest'),
        ),
        AuthMessages(state: state),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (isRegisterMode) {
      final String password = passwordController.text.trim();
      if (password != confirmPasswordController.text.trim()) {
        locator<SnackbarService>().showError('Passwords do not match.');
        return;
      }
      context.read<AuthCubit>().signUpWithEmail(
            email: emailController.text.trim(),
            password: password,
            displayName: displayNameController.text.trim(),
          );
      return;
    }
    context.read<AuthCubit>().signInWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }
}
