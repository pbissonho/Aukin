import 'dart:async';

import 'package:meta/meta.dart';
import 'package:identity_client/identity_client.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class IdentiyUser {
  IdentiyUser({this.userName, this.email, this.roles});

  factory IdentiyUser.fromTokenJson(Map<String, dynamic> claims) {
    var roles = (claims['role'] as List).map((f) => f.toString()).toList();
    var name = claims['unique_name'][0];
    var user = IdentiyUser(userName: name, roles: roles, email: '');
    return user;
  }

  final String userName;
  final String email;
  final List<String> roles;
}

enum UserAuthenticationStatus {
  unknown,
  signedIn,
  signedOut,
}

class IdentiyAuth {
  IdentiyAuth(this._client);

  final IdentityClient _client;

  Stream<UserAuthenticationStatus> get authenticationStatus {
    return _client.authenticationStatus.map((status) {
      switch (status) {
        case AuthenticationStatus.authenticated:
          return UserAuthenticationStatus.signedIn;
        case AuthenticationStatus.unauthenticated:
          return UserAuthenticationStatus.signedOut;
        case AuthenticationStatus.initial:
        default:
          return UserAuthenticationStatus.unknown;
      }
    });
  }

  Stream<IdentiyUser> get currentUser async* {
    yield* _client.fresh.currentToken.map((token) {
      if (token == null) return IdentiyUser(email: "", userName: "", roles: []);
      return IdentiyUser.fromTokenJson(JWT.parse(token.accessToken).claims);
    });
  }

  Future<IdentiyUser> signInWithAccessCredentials({
    @required String username,
    @required String password,
  }) async {
    var token = await _client.signInWithAccessCredentials(
      username: username,
      password: password,
    );
    IdentiyUser.fromTokenJson(JWT.parse(token.accessToken).claims);
  }

  Future<void> createUserWithRegisterCredentials({
    @required String username,
    @required String password,
    @required String useEmail,
  }) async {
    await _client.createUserWithRegisterCredentials(
        username: username, password: password, userEmail: useEmail);
  }

  Future<void> signOut() async {
    await _client.unauthenticate();
  }
}

/*
  int _secondsSinceEpoch(DateTime dateTime) {
    return (dateTime.millisecondsSinceEpoch / 1000).floor();
  }

  bool isValidUser() {
    var currentTime = DateTime.now();
    var currentTimestamp = _secondsSinceEpoch(currentTime);

    if (_currentUser == null) return false;

    if (_currentUser.jwtToken.expiresAt is int) {
      if (currentTimestamp <= _currentUser.jwtToken.expiresAt) {
        return true;
      }
    }

    return true;
  }
*/
