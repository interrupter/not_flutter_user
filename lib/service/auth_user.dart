import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String id;
  final String username;
  final bool active;
  final List<String> role;
  final bool emailConfirmed;
  final bool telephoneConfirmed;
  final String? email;
  final String? token;

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.emailConfirmed,
    required this.telephoneConfirmed,
    required this.role,
    required this.active,
  });

  factory AuthUser.fromAuthLoginResponse(dynamic response) {
    List<String> roles = [];
    (response['role'] as List<dynamic>).forEach((rol) {
      roles.add(rol as String);
    });
    return AuthUser(
      id: response['_id'].toString(),
      username: response['username'],
      email: response['email'],
      emailConfirmed: response['emailConfirmed'] ?? false,
      telephoneConfirmed: response['telephoneConfirmed'] ?? false,
      active: response['active'],
      role: roles,
      token: response['token'],
    );
  }

  factory AuthUser.fromAuthRegisterResponse(dynamic response) => AuthUser(
        id: response['_id'].toString(),
        username: response['username'],
        email: response['email'],
        emailConfirmed: response['emailConfirmed'],
        telephoneConfirmed: response['emailConfirmed'],
        active: response['active'],
        role: response['role'],
        token: response['token'],
      );

  factory AuthUser.empty() => const AuthUser(
        id: '',
        username: '',
        email: '',
        emailConfirmed: false,
        telephoneConfirmed: false,
        active: false,
        role: [],
        token: '',
      );
}
