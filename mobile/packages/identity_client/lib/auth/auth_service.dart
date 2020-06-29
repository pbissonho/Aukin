import 'package:dio/dio.dart';
import 'models.dart';

class IdentityServiceException implements Exception {}

class IdentityService {
  IdentityService(this._dio);

  final Dio _dio;

  Future<IdentityToken> signInWithAccessCredentials(
      String userName, String password) async {
    Response response;

    var accessCredentias = AccessCredentials(
        userName: userName,
        password: password,
        refreshToken: "",
        grantType: "password");

    try {
      response =
          await _dio.post("/auth/login", data: accessCredentias.toJson());

      if (response.statusCode == 200) {
        var token = IdentityToken.fromJson(response.data);
        return token;
      } else {
        throw IdentityServiceException();
      }
    } on DioError {
      throw IdentityServiceException();
    }
  }

  Future<bool> createUserWithRegisterCredentials(
      RegisterCredentials registerCredentials) async {
    Response response;

    try {
      response =
          await _dio.post("/auth/Signup", data: registerCredentials.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw IdentityServiceException();
      }
    } on DioError {
      throw IdentityServiceException();
    }
  }
}

class FakeIdentityService implements IdentityService {
  Future<IdentityToken> signInWithAccessCredentials(
      String userName, String password) async {
    return IdentityToken(
        accessToken:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJwZWRybzUiLCJwZWRybzUiXSwianRpIjoiOGJhNzQzMjE0YTY2NGYzMDg4YTRkOWYzYzE3OWJkOTIiLCJyb2xlIjpbIkFjZXNzby1BRE1JTiIsIkFjZXNzby1CQVNJQyIsIkFjZXNzby1BUElQcm9kdXRvcyJdLCJuYmYiOjE1OTMzNTE1OTMsImV4cCI6MTU5MzM1MzM5MywiaWF0IjoxNTkzMzUxNTkzLCJpc3MiOiJBUElQcm9kdXRvcyIsImF1ZCI6IkNsaWVudHMtQVBJUHJvZHV0b3MifQ.TPc-U4EcIxJQx0oiO-hKC0c7-awtH7XpwYvdm9AtXPwrvUp1MyH37iVAyQKMNW8Hsff_M0lJAy2Qt0QQ1kunG0Y7fn2DsuDzUYcsxnYhRS5xnE1eTn32iorxL9Jziug_porHlbl1elhE0A_nH9kd9PMyY0tSph3vpobyZkesD_X2Q19uynzgVPCjAv7o0dW98b1PruRVzvLE1E2tlm71fPiOeQmUqaOqw2ZQQHWMTVsihO74PnbcWH2ajQImOI7h8jvy_alM5VHQzAWnyK7SP25sa0IkPU-B1MJju-MVl9J1ruNEWeMhCQuT7Nk78KeFRnXAiDv49BJQ_aJ4XU05lg',
        refreshToken:
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvd3AtZmx1dHRlci4wMDB3ZWJob3N0YXBwLmNvbSIsImlhdCI6MTU3MTIzNzc3OCwibmJmIjoxNTcxMjM3Nzc4LCJleHAiOjE1NzE4NDI1NzgsImRhdGEiOnsidXNlciI6eyJpZCI6IjEifX19.VbvucX5zxf2eqzKU0ozYd4Lg5pD-CGkoqh7DMHVEiXM');
  }

  Future<bool> createUserWithRegisterCredentials(
      RegisterCredentials registerCredentials) async {
    return true;
  }

  @override
  Dio get _dio => Dio();
}
