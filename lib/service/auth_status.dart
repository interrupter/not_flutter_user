const defaultRole = 'guest';

class AuthStatus {
  late final List<String> role;
  late final bool active;
  late final String id;
  late final String username;
  late final String email;
  late final String token;

  AuthStatus.fromJSON(bool success, dynamic json) {
    if (success) {
      if (json['active']) {
        active = json['active'] as bool;
      }
      if (json['id']) {
        id = json['id'] as String;
      }
      if (json['username']) {
        username = json['username'] as String;
      }
      if (json['email']) {
        email = json['email'] as String;
      }
      if (json['token']) {
        token = json['token'] as String;
      }
      if (json['role'] is List<String>) {
        role = json['role'] as List<String>;
      }
    } else {
      active = false;
      role = [defaultRole];
    }
  }
}
