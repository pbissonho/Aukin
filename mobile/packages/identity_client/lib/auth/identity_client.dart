import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:identity_client/identity_client.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'models.dart';

class IdentityFresh extends Fresh<IdentityToken> {
  IdentityFresh(TokenStorage<IdentityToken> tokenStorage)
      : super(
          tokenStorage: tokenStorage,
          refreshToken: (token, client) async {
            return IdentityToken(
              accessToken: 'access_token_',
              refreshToken: 'refresh_token_',
            );
          },
          shouldRefresh: (_) => false,
          tokenHeader: (IdentityToken token) {
            return {"Authorization": "Bearer ${token.accessToken}"};
          },
        );
}

class SharedTokenStorage implements TokenStorage<IdentityToken> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Future<void> delete() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('identityToken');
  }

  @override
  Future<IdentityToken> read() async {
    try {
      final SharedPreferences prefs = await _prefs;
      var token = await prefs.get('identityToken');
      return IdentityToken.fromJson(json.decode(token));
    } catch (erro) {
      return null;
    }
  }

  @override
  Future<void> write(IdentityToken token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('identityToken', json.encode(token.toJson()));
  }
}

class IdentityClient {
  final Dio _httpClient;
  final IdentityService identityService;
  final IdentityFresh fresh;

  IdentityClient(
      {@required this.fresh,
      @required this.identityService,
      @required Dio httpClient})
      : _httpClient = httpClient..interceptors.add(fresh);

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
        userEmail: userEmail,
        password: password,
        userName: username,
        confirmPassword: password));
  }

  Future<void> unauthenticate() async {
    await fresh.removeToken();
  }
}
