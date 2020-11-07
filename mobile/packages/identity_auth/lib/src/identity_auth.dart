import 'dart:async';

import 'package:identity_client/auth/models.dart';
import 'package:meta/meta.dart';
import 'package:identity_client/identity_client.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class IdentiyClaim {
  IdentiyClaim(this.value, this.type);

  final String value;
  final String type;
}

class IdentiyUser {
  IdentiyUser({this.accessClaims, this.userName, this.email, this.roles});

  factory IdentiyUser.fromToken(IdentityToken token) {
    var claims = JWT.parse(token.accessToken).claims;
    var role = (claims['role']);
    IdentiyUser user;
    if (role is List) {
      user = IdentiyUser(
          userName: token.userToken.name,
          roles: ["BASIC"],
          email: token.userToken.email,
          accessClaims: token.userToken.claims
              .map<IdentiyClaim>((c) => IdentiyClaim(c.value, c.type))
              .toList());
    } else {
      user = IdentiyUser(
          userName: token.userToken.name,
          roles: [role],
          email: token.userToken.email,
          accessClaims: token.userToken.claims
              .map<IdentiyClaim>((c) => IdentiyClaim(c.value, c.type))
              .toList());
    }

    return user;
  }

  final String userName;
  final String email;
  final List<String> roles;
  final List<IdentiyClaim> accessClaims;

  @override
  String toString() {
    return "Username: $userName\n Email: $email\n Roles: $roles\n Claims: $accessClaims";
  }
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

  Future<IdentiyUser> get currentUser async {
    return await _client.fresh.token.then((token) {
      if (token == null)
        return IdentiyUser(
            email: "", userName: "", roles: [], accessClaims: []);
      return IdentiyUser.fromToken(token);
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
    return IdentiyUser.fromToken(token);
  }

  Future<void> createUserWithRegisterCredentials({
    @required String username,
    @required String password,
    @required String useEmail,
  }) async {
    await _client.createUserWithRegisterCredentials(
        username: username, password: password, userEmail: useEmail);
  }

  Future<void> resetPassword(
      {@required String password,
      @required String confirmPassword,
      @required String email,
      @required String token}) async {
    await _client.resetPassword(
        email: email,
        token: token,
        password: password,
        confirmPassword: confirmPassword);
  }

  Future<String> verifyCode(
      {@required String code, @required String email}) async {
    var token = await _client.verifyCode(
      email: email,
      code: code,
    );
    return token;
  }

  Future<void> generatePasswordResetToken({
    @required String email,
  }) async {
    await _client.generatePasswordResetToken(email: email);
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
