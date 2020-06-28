import 'package:equatable/equatable.dart';

class AccessCredentials {
  String userName;
  String password;
  String refreshToken;
  String grantType;

  AccessCredentials(
      {this.userName, this.password, this.refreshToken, this.grantType});

  AccessCredentials.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    password = json['Password'];
    refreshToken = json['RefreshToken'];
    grantType = json['GrantType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['Password'] = this.password;
    data['RefreshToken'] = this.refreshToken;
    data['GrantType'] = this.grantType;
    return data;
  }
}

class RegisterCredentials {
  String userName;
  String userEmail;
  String password;
  String confirmPassword;

  RegisterCredentials(
      {this.userName, this.userEmail, this.password, this.confirmPassword});

  RegisterCredentials.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userEmail = json['userEmail'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}

class IdentityToken {
  bool authenticated;
  String created;
  String expiration;
  String accessToken;
  String refreshToken;
  String message;

  IdentityToken(
      {this.authenticated = false,
      this.created = '',
      this.expiration = '',
      this.accessToken = '',
      this.refreshToken = '',
      this.message = ''});

  IdentityToken.fromJson(Map<String, dynamic> json) {
    authenticated = json['authenticated'];
    created = json['created'];
    expiration = json['expiration'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authenticated'] = this.authenticated;
    data['created'] = this.created;
    data['expiration'] = this.expiration;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['message'] = this.message;
    return data;
  }
}

class UserCredentials with EquatableMixin {
  String name;
  String password;

  UserCredentials({this.name, this.password});

  UserCredentials.fromMap(Map<String, dynamic> map) {
    name = map["name"];
    password = map["password"];
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "password": password};
  }

  @override
  List<Object> get props => [name, password];
}
