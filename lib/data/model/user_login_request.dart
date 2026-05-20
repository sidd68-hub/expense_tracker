class UserLoginRequest {
  String? username;
  String? email;
  String? password;

  UserLoginRequest({this.username, this.email, this.password});

  UserLoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}