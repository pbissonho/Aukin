class AccessCredentials {
  AccessCredentials({this.name, this.password});

  AccessCredentials.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
  }

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

  RegisterCredentials.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

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
