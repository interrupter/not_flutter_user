import 'dart:developer';

import 'package:not_flutter_manifest/credentials.dart';
import 'package:not_flutter_manifest/response/response.dart';
import 'package:not_flutter_manifest/response/response_exception.dart';

import 'package:not_flutter_manifest/manifest.dart';
import './auth_user.dart';
import 'auth_provider.dart';
import 'auth_exceptions.dart';

const authModel = 'user';

class NotNodeAuthProvider implements AuthProvider {
  @override
  AuthUser? currentUser;

  @override
  Future<AuthUser> registerNewUser({
    required String email,
    required String password,
  }) async {
    try {
      NotResponse res = await NotManifest().getModel(authModel).request(
          'register', {'email': email, 'password': password}).getResponse();
      final authUser = AuthUser.fromAuthRegisterResponse(res.getResult());
      final token = authUser.token;
      if (token != null && token.isNotEmpty) {
        NotManifestCredatials().byBearer(token);
      }
      currentUser = authUser;
      return authUser;
    } on NotResponseException catch (e) {
      switch (e.message) {
        case 'not-user:user_uniqueness_verification_error':
          throw EmailAlreadyInUseAuthEception();
        case 'not-user:email_not_valid':
          throw InvalidEmailAuthEception();
        case 'not-user:password_incorrect':
          throw WrongPasswordAuthEception();
        default:
          throw GenericAuthEception();
      }
    } catch (_) {
      throw GenericAuthEception();
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      NotResponse res = await NotManifest().getModel(authModel).request(
          'login', {'email': email, 'password': password}).getResponse();
      final authUser = AuthUser.fromAuthLoginResponse(res.getResult());
      final token = authUser.token;
      if (token != null && token.isNotEmpty) {
        NotManifestCredatials().byBearer(token);
      }
      currentUser = authUser;
      return authUser;
    } on NotResponseException catch (e) {
      log(e.toString());
      log(e.statusMessage ?? '');
      switch (e.message) {
        case 'not-user:password_length_not_valid':
          throw PasswordIsTooShortAuthException();
        case 'not-user:user_not_found':
          throw UserNotFoundAuthEception();
        case 'not-user:email_not_valid':
          throw InvalidEmailAuthEception();
        case 'not-user:password_incorrect':
          throw WrongPasswordAuthEception();
        default:
          throw GenericAuthEception();
      }
    } catch (_) {
      throw GenericAuthEception();
    }
  }

  @override
  Future<void> logout() async {
    await NotManifest().fetch(authModel, 'logout', {});
  }

  @override
  Future<void> requestEmailConfirmation() async {
    await NotManifest().fetch(authModel, 'requestEmailConfirmation', {});
  }

  @override
  Future<void> initialize(String serverUrl) async {
    await NotManifest().setServerUrl(serverUrl).update();
  }

  @override
  Future<void> requestPasswordReset({required String toEmail}) async {
    try {
      await NotManifest()
          .getModel(authModel)
          .request('requestPasswordReset', {'email': toEmail}).getResponse();
    } on NotResponseException catch (e) {
      switch (e.message) {
        case 'not-user:email_not_valid':
          throw InvalidEmailAuthEception();
        case 'not-user:user_not_found':
          throw UserNotFoundAuthEception();
        default:
          throw GenericAuthEception();
      }
    } catch (_) {
      throw GenericAuthEception();
    }
  }

  @override
  Future<AuthUser> loginByCode({
    required String code,
  }) async {
    try {
      NotResponse res = await NotManifest()
          .getModel(authModel)
          .request('loginByCode', {'code': code})
          .addParam('noRedirect', '1')
          .getResponse();
      final authUser = AuthUser.fromAuthLoginResponse(res.getResult());
      final token = authUser.token;
      if (token != null && token.isNotEmpty) {
        NotManifestCredatials().byBearer(token);
      }
      return authUser;
    } on NotResponseException catch (e) {
      switch (e.message) {
        case 'not-user:password_length_not_valid':
          throw PasswordIsTooShortAuthException();
        case 'not-user:user_not_found':
          throw UserNotFoundAuthEception();
        case 'not-user:email_not_valid':
          throw InvalidEmailAuthEception();
        case 'not-user:password_incorrect':
          throw WrongPasswordAuthEception();
        default:
          throw GenericAuthEception();
      }
    } catch (_) {
      throw GenericAuthEception();
    }
  }

  @override
  Future<void> requestLoginCodeOnEmail({required String toEmail}) {
    // TODO: implement requestLoginCodeOnEmail
    throw UnimplementedError();
  }

  @override
  Future<void> requestLoginCodeOnTelephone({required String toTelephone}) {
    // TODO: implement requestLoginCodeOnTelephone
    throw UnimplementedError();
  }
}
