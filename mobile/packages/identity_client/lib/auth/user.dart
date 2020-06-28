import 'package:corsac_jwt/corsac_jwt.dart';
import 'models.dart';

class AuthUser {
  IdentityToken identityToken;
  JWT jwtToken;

  AuthUser(this.identityToken) {
    jwtToken = JWT.parse(identityToken.accessToken);
  }

  String get name => jwtToken.claims["unique_name"][0];
}
