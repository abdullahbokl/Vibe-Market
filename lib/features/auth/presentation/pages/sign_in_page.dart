import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../widgets/auth_page_body.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({required this.onAuthenticated, super.key});

  final VoidCallback onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous.session != current.session,
      listener: (BuildContext context, AuthState state) {
        if (state.session.isAuthenticated || state.session.isGuest) {
          onAuthenticated();
        }
      },
      child: const AuthPageBody(),
    );
  }
}
