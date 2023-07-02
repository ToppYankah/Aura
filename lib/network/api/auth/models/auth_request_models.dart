import 'package:aura/network/api/api_core.dart';

class UserLoginRequest implements Serializable {
  String? email;
  String? password;

  UserLoginRequest({
    this.email,
    this.password,
  });

  factory UserLoginRequest.fromMap(Map<String, dynamic>? json) =>
      UserLoginRequest(
        email: json?["email"],
        password: json?["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
