class AccessCredentials {
  AccessCredentials({this.name, this.password});

  String name;
  String password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    return data;
  }
}

class RegisterCredentials {
  RegisterCredentials(
      {this.email, this.name, this.password, this.confirmPassword});

  String email;
  String name;
  String password;
  String confirmPassword;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}

class IdentityToken {
  String accessToken;
  int expiresIn;
  String tokenType;
  UserToken userToken;

  IdentityToken(
      {this.accessToken, this.expiresIn, this.tokenType, this.userToken});

  IdentityToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiresIn = json['expiresIn'];
    tokenType = json['tokenType'];
    userToken = json['userToken'] != null
        ? new UserToken.fromJson(json['userToken'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['expiresIn'] = this.expiresIn;
    data['tokenType'] = this.tokenType;
    if (this.userToken != null) {
      data['userToken'] = this.userToken.toJson();
    }
    return data;
  }
}

class UserToken {
  String id;
  String email;
  String name;
  List<Claims> claims;

  UserToken({this.id, this.email, this.name, this.claims});

  UserToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    if (json['claims'] != null) {
      claims = new List<Claims>();
      json['claims'].forEach((v) {
        claims.add(new Claims.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    if (this.claims != null) {
      data['claims'] = this.claims.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Claims {
  String value;
  String type;

  Claims({this.value, this.type});

  Claims.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class ErrorModel {
  List<String> messages;
  int statusCode;
  String statusDescription;

  ErrorModel({this.messages, this.statusCode, this.statusDescription});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    messages = json['Messages'].cast<String>();
    statusCode = json['StatusCode'];
    statusDescription = json['StatusDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Messages'] = this.messages;
    data['StatusCode'] = this.statusCode;
    data['StatusDescription'] = this.statusDescription;
    return data;
  }
}

class ForgotPasswordModel {
  ForgotPasswordModel({this.email});
  String email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class VerifyCodeModel {
  VerifyCodeModel({this.email, this.code});

  String email;
  String code;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['code'] = this.code;
    return data;
  }
}

class VerifyCodeResponse {
  VerifyCodeResponse({this.token});

  VerifyCodeResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
  String token;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

class ResetPasswordModel {
  ResetPasswordModel(
      {this.password, this.confirmPassword, this.email, this.token});

  String password;
  String confirmPassword;
  String email;
  String token;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['email'] = this.email;
    data['token'] = this.token;
    return data;
  }
}
