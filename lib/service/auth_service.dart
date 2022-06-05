import 'auth_provider.dart';
import 'auth_user.dart';
import 'not_node_auth_provider.dart';

class AuthService implements AuthProvider {
  static const modelName = 'user';

  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.notNode() => AuthService(NotNodeAuthProvider());

  @override
  Future<AuthUser> registerNewUser({
    required String username,
    required String email,
    required String password,
    required String telephone,
  }) =>
      provider.registerNewUser(
        username: username,
        email: email,
        password: password,
        telephone: telephone,
      );

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> requestEmailConfirmation() =>
      provider.requestEmailConfirmation();

  @override
  Future<void> initialize(String serverUrl) async {
    return provider.initialize(serverUrl);
  }

  @override
  Future<void> requestPasswordReset({required String toEmail}) =>
      provider.requestPasswordReset(toEmail: toEmail);

  @override
  Future<AuthUser> loginByCode({required String code}) =>
      provider.loginByCode(code: code);

  @override
  Future<void> requestLoginCodeOnEmail({required String toEmail}) =>
      provider.requestLoginCodeOnEmail(toEmail: toEmail);

  @override
  Future<void> requestLoginCodeOnTelephone({required String toTelephone}) =>
      provider.requestLoginCodeOnTelephone(toTelephone: toTelephone);

  @override
  AuthUser? get currentUser => provider.currentUser;
}
