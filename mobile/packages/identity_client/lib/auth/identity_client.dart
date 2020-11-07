import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:identity_client/identity_client.dart';
import 'package:meta/meta.dart';
import 'auth_service.dart';
import 'models.dart';

class IdentityFresh extends Fresh<IdentityToken> {
  IdentityFresh(TokenStorage<IdentityToken> tokenStorage)
      : super(
          tokenStorage: tokenStorage,
          refreshToken: (token, client) async {
            return IdentityToken(
              accessToken: 'access_token_',
            );
          },
          shouldRefresh: (_) => false,
          tokenHeader: (IdentityToken token) {
            return {"Authorization": "Bearer ${token.accessToken}"};
          },
        );
}

class SecureTokenStorage implements TokenStorage<IdentityToken> {
  final _storage = FlutterSecureStorage();

  @override
  Future<void> delete() async {
    _storage.delete(key: 'identityToken');
  }

  @override
  Future<IdentityToken> read() async {
    try {
      var token = await _storage.read(key: 'identityToken');
      return IdentityToken.fromJson(json.decode(token));
    } catch (erro) {
      return null;
    }
  }

  @override
  Future<void> write(IdentityToken token) async {
    await _storage.write(
        key: 'identityToken', value: json.encode(token.toJson()));
  }
}

class IdentityClient {
  IdentityClient(
      {@required this.fresh,
      @required this.identityService,
      @required Dio httpClient}) {
    httpClient..interceptors.add(fresh);
  }

  final IdentityService identityService;
  final IdentityFresh fresh;

  Stream<AuthenticationStatus> get authenticationStatus =>
      fresh.authenticationStatus;

  Future<IdentityToken> signInWithAccessCredentials({
    @required String username,
    @required String password,
  }) async {
    var token =
        await identityService.signInWithAccessCredentials(username, password);

    await fresh.setToken(token);
    return token;
  }

  Future<void> createUserWithRegisterCredentials({
    @required String username,
    @required String password,
    @required String userEmail,
  }) async {
    await identityService.createUserWithRegisterCredentials(RegisterCredentials(
        email: userEmail,
        password: password,
        name: username,
        confirmPassword: password));
  }

  Future<void> resetPassword(
      {@required String password,
      @required String confirmPassword,
      @required String email,
      @required String token}) async {
    await identityService.resetPassword(ResetPasswordModel(
        email: email,
        password: password,
        token: token,
        confirmPassword: confirmPassword));
  }

  Future<String> verifyCode(
      {@required String email, @required String code}) async {
    var result = await identityService.verifyCode(VerifyCodeModel(
      email: email,
      code: code,
    ));
    return result.token;
  }

  Future<void> generatePasswordResetToken({
    @required String email,
  }) async {
    await identityService.generatePasswordResetToken(ForgotPasswordModel(
      email: email,
    ));
  }

  Future<void> unauthenticate() async {
    await fresh.clearToken();
  }
}
