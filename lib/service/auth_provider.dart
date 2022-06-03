import 'auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize(String serverUrl);

  Future<void> logout();
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> loginByCode({
    required String code,
  });

  Future<AuthUser> registerNewUser({
    required String email,
    required String password,
  });

  Future<void> requestEmailConfirmation();
  Future<void> requestPasswordReset({required String toEmail});
  Future<void> requestLoginCodeOnEmail({required String toEmail});
  Future<void> requestLoginCodeOnTelephone({required String toTelephone});
}
