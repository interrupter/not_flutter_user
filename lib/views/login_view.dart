import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/auth_exceptions.dart';
import '../service/bloc/auth_bloc.dart';
import '../service/bloc/auth_events.dart';
import '../service/bloc/auth_states.dart';

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthEception) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials!');
          } else if (state.exception is WrongPasswordAuthEception) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthEception) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                    'Please log in to your account in order to interact with and create notes!'),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(hintText: 'Email'),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogin(
                              email,
                              password,
                            ),
                          );
                    },
                    child: const Text('Login')),
                TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text('I forgot my password')),
                TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    child: const Text('Not registered yet? Register here!')),
              ],
            ),
          )),
    );
  }
}
