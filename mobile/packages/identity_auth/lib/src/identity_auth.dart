import 'dart:async';

import 'package:meta/meta.dart';
import 'package:identity_client/identity_client.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

IdentiyUser _parserToUser(String accessToken) {
  var decodedToken = new JWT.parse(accessToken);
  var roles = (decodedToken.claims['role'] as List).map((f) => '$f').toList();
  var name = decodedToken.claims['unique_name'][0];
  var user = IdentiyUser(userName: name, roles: roles, email: '');
  return user;
}

class IdentiyUser {
  final String userName;
  final String email;
  final List<String> roles;

  IdentiyUser({this.userName, this.email, this.roles});
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
    yield* _client.fresh.currentToken
        .map((token) => _parserToUser(token.accessToken));
  }

  Future<IdentiyUser> signInWithAccessCredentials({
    @required String username,
    @required String password,
  }) async {
    var token = await _client.signInWithAccessCredentials(
      username: username,
      password: password,
    );
    return _parserToUser(token.accessToken);
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
