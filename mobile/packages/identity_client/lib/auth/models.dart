class AccessCredentials {
  AccessCredentials(
      {this.userName, this.password, this.refreshToken, this.grantType});

  String userName;
  String password;
  String refreshToken;
  String grantType;

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
  RegisterCredentials(
      {this.userName, this.userEmail, this.password, this.confirmPassword});

  String userName;
  String userEmail;
  String password;
  String confirmPassword;

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

  bool authenticated;
  String created;
  String expiration;
  String accessToken;
  String refreshToken;
  String message;

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
