import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/bloc/auth_events.dart';

import '../service/bloc/auth_bloc.dart';

class ConfirmEmailView extends StatefulWidget {
  const ConfirmEmailView({Key? key}) : super(key: key);

  @override
  State<ConfirmEmailView> createState() => _ConfirmEmailViewState();
}

class _ConfirmEmailViewState extends State<ConfirmEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Column(
          children: [
            const Text(
                'We\'ve have sent you an email verification. Please open it to verify your account.'),
            const Text(
                "If you haven't recieved verification email yet, press the button below"),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventRequestedEmailConfirmation(),
                    );
              },
              child: const Text("Send email verification"),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogout(),
                    );
              },
              child: const Text("Restart"),
            ),
          ],
        ));
  }
}
