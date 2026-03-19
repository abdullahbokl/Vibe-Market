import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'auth_form.dart';
import 'auth_header.dart';
import 'auth_mode_switch.dart';

class AuthPageBody extends StatefulWidget {
  const AuthPageBody({super.key});

  @override
  State<AuthPageBody> createState() => _AuthPageBodyState();
}

class _AuthPageBodyState extends State<AuthPageBody> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (BuildContext context, AuthState state) {
              return ListView(
                children: <Widget>[
                  AuthHeader(isRegisterMode: _isRegisterMode),
                  const SizedBox(height: 24),
                  AuthModeSwitch(
                    isRegisterMode: _isRegisterMode,
                    isBusy: state.isBusy,
                    onModeChanged: (bool value) => setState(() => _isRegisterMode = value),
                  ),
                  AuthForm(
                    state: state,
                    isRegisterMode: _isRegisterMode,
                    displayNameController: _displayNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
