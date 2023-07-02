import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/auth/models/auth_request_models.dart';
import 'package:aura/network/api/auth/models/auth_response_models.dart';
import 'package:aura/network/requester.dart';

class AuthApi extends ApiCore {
  AuthApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<UserLoginResponse>>> loginUser(
      {required UserLoginRequest loginRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.authEndpoint.loginUser(loginRequest: loginRequest),
    );

    final data = BaseResponse<UserLoginResponse>.fromJson(
        response.response, (data) => UserLoginResponse.fromJson(data));

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
