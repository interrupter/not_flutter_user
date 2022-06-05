import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  final String serverUrl;
  const AuthEventInitialize(this.serverUrl);
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password);
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventRequestedEmailConfirmation extends AuthEvent {
  const AuthEventRequestedEmailConfirmation();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String telephone;
  const AuthEventRegister(
    this.username,
    this.email,
    this.password,
    this.telephone,
  );
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
