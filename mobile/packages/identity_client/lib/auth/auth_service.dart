import 'dart:convert';

import 'package:dio/dio.dart';
import 'models.dart';

class IdentityServiceException implements Exception {
  IdentityServiceException(this.messages);

  final List<String> messages;
}

class ServerException implements Exception {
  ServerException(this.error);

  final ErrorModel error;
}

class IdentityService {
  IdentityService(this._dio);

  final Dio _dio;

  Future<IdentityToken> signInWithAccessCredentials(
      String userName, String password) async {
    Response response;

    var accessCredentias = AccessCredentials(
      name: userName,
      password: password,
    );

    try {
      response = await _dio.post("/api/account/login",
          data: accessCredentias.toJson());

      if (response.statusCode == 200) {
        var token = IdentityToken.fromJson(response.data);
        return token;
      } else
        throw ServerException(ErrorModel.fromJson(response.data));
    } on DioError catch (error) {
      if (error.response.statusCode == 400) {
        throw ServerException(
            ErrorModel.fromJson(json.decode(error.response.data)));
      } else {
        rethrow;
      }
    }
  }

  Future<void> generatePasswordResetToken(ForgotPasswordModel model) async {
    Response response;

    try {
      response = await _dio.post("/api/account/send", data: model.toJson());

      if (response.statusCode != 200) {
        throw ServerException(ErrorModel.fromJson(response.data));
      }
    } on DioError catch (error) {
      throw ServerException(
          ErrorModel.fromJson(json.decode(error.response.data)));
    }
  }

  Future<VerifyCodeResponse> verifyCode(VerifyCodeModel model) async {
    Response response;

    try {
      response =
          await _dio.post("/api/account/reset-token", data: model.toJson());

      if (response.statusCode == 200) {
        return VerifyCodeResponse.fromJson(response.data);
      } else {
        throw ServerException(ErrorModel.fromJson(response.data));
      }
    } on DioError catch (error) {
      throw ServerException(
          ErrorModel.fromJson(json.decode(error.response.data)));
    }
  }

  Future<void> resetPassword(ResetPasswordModel model) async {
    Response response;

    try {
      response = await _dio.post("/api/account/reset", data: model.toJson());

      if (response.statusCode != 200) {
        throw ServerException(ErrorModel.fromJson(response.data));
      }
    } on DioError catch (error) {
      throw ServerException(
          ErrorModel.fromJson(json.decode(error.response.data)));
    }
  }

  Future<bool> createUserWithRegisterCredentials(
      RegisterCredentials registerCredentials) async {
    Response response;

    try {
      response = await _dio.post("/api/account/register",
          data: registerCredentials.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw IdentityServiceException(['', '']);
      }
    } on DioError catch (error) {
      if (error.response.statusCode == 400) {
        throw ServerException(
            ErrorModel.fromJson(json.decode(error.response.data)));
      } else {
        throw IdentityServiceException(['', '']);
      }
    }
  }
}

class FakeIdentityService implements IdentityService {
  @override
  Dio get _dio => Dio();

  Future<IdentityToken> signInWithAccessCredentials(
      String userName, String password) async {
    return IdentityToken(
        userToken: UserToken(
            claims: [],
            id: '356145465',
            email: 'pedro.bissonho@gmail.com',
            name: "Pedro Bissonho"),
        tokenType: 'Bearer',
        accessToken:
            'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6WyJwZWRybzUiLCJwZWRybzUiXSwianRpIjoiOGJhNzQzMjE0YTY2NGYzMDg4YTRkOWYzYzE3OWJkOTIiLCJyb2xlIjpbIkFjZXNzby1BRE1JTiIsIkFjZXNzby1CQVNJQyIsIkFjZXNzby1BUElQcm9kdXRvcyJdLCJuYmYiOjE1OTMzNTE1OTMsImV4cCI6MTU5MzM1MzM5MywiaWF0IjoxNTkzMzUxNTkzLCJpc3MiOiJBUElQcm9kdXRvcyIsImF1ZCI6IkNsaWVudHMtQVBJUHJvZHV0b3MifQ.TPc-U4EcIxJQx0oiO-hKC0c7-awtH7XpwYvdm9AtXPwrvUp1MyH37iVAyQKMNW8Hsff_M0lJAy2Qt0QQ1kunG0Y7fn2DsuDzUYcsxnYhRS5xnE1eTn32iorxL9Jziug_porHlbl1elhE0A_nH9kd9PMyY0tSph3vpobyZkesD_X2Q19uynzgVPCjAv7o0dW98b1PruRVzvLE1E2tlm71fPiOeQmUqaOqw2ZQQHWMTVsihO74PnbcWH2ajQImOI7h8jvy_alM5VHQzAWnyK7SP25sa0IkPU-B1MJju-MVl9J1ruNEWeMhCQuT7Nk78KeFRnXAiDv49BJQ_aJ4XU05lg');
  }

  Future<bool> createUserWithRegisterCredentials(
      RegisterCredentials registerCredentials) async {
    return true;
  }

  @override
  Future<void> generatePasswordResetToken(ForgotPasswordModel model) async {
    await Future.delayed(Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPassword(ResetPasswordModel model) async {
    await Future.delayed(Duration(milliseconds: 300));
  }

  @override
  Future<VerifyCodeResponse> verifyCode(VerifyCodeModel model) async {
    return VerifyCodeResponse(token: "");
  }
}
