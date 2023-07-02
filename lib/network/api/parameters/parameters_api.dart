import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/parameters/models/parameters_request.dart';
import 'package:aura/network/api/parameters/models/parameters_response.dart';
import 'package:aura/network/requester.dart';

class ParametersApi extends ApiCore {
  ParametersApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<ParametersResponse>>> getParameters(
      {required ParametersRequest parametersRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.parametersEndpoint
          .getParameters(parametersRequest: parametersRequest),
    );

    final data = BaseResponse<ParametersResponse>.fromJson(
      response.response,
      (data) => ParametersResponse.fromJson(data),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
