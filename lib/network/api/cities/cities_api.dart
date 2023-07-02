import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/cities/models/cities_request.dart';
import 'package:aura/network/api/cities/models/cities_respone.dart';
import 'package:aura/network/requester.dart';

class CitiesApi extends ApiCore {
  CitiesApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<CitiesResponse>>> getCities(
      {required CitiesRequest citiesRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint:
          endpoints.citiesEndpoint.getCities(citiesRequest: citiesRequest),
    );

    final data = BaseResponse<CitiesResponse>.fromJson(
      response.response,
      (data) => CitiesResponse.fromJson(data!),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
