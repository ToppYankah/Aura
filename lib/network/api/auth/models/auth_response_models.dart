import 'package:aura/network/api/api_core.dart';

class UserLoginResponse implements Serializable {
  String? email;
  String? password;

  UserLoginResponse({
    this.email,
    this.password,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic>? json) =>
      UserLoginResponse(
        email: json?["email"],
        password: json?["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
