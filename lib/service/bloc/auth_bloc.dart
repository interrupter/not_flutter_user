import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_provider.dart';
import './auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });

    on<AuthEventRequestedEmailConfirmation>((event, emit) async {
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final username = event.username;
      final email = event.email;
      final password = event.password;
      final telephone = event.telephone;
      try {
        await provider.registerNewUser(
          username: username,
          email: email,
          password: password,
          telephone: telephone,
        );
        emit(const AuthStateEmailNeedsConfirmation(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize(event.serverUrl);
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.emailConfirmed) {
        emit(const AuthStateEmailNeedsConfirmation(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you in',
        ));
        final email = event.email;
        final password = event.password;
        final user = await provider.login(
          email: email,
          password: password,
        );
        if (user.emailConfirmed) {
          log('email confirmed');
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } else {
          log('email not confirmed!');
          emit(AuthStateEmailNeedsConfirmation(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I log you out',
        ));
        await provider.logout();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ),
      );
      final email = event.email;
      if (email == null) {
        return;
      }
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ),
      );
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.requestPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        exception = e;
        didSendEmail = false;
      }
      emit(
        AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ),
      );
    });
  }
}
