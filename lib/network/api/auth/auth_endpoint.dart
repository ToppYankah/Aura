import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/auth/models/auth_request_models.dart';
import 'package:aura/network/api/endpoint_core.dart';

class AuthEndpoint with EndpointCore {
  final baseUrl = "zomujo-phoenix.azurewebsites.net";

  Future<ApiEndpoint> loginUser(
      {required UserLoginRequest loginRequest}) async {
    return await createEndpoint(
      authority: baseUrl,
      path: '/api/Users/Login',
      requestType: RequestType.POST,
      body: loginRequest.toJson(),
    );
  }
}
