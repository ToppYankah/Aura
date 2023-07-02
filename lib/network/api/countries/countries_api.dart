import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/countries/models/countries_request.dart';
import 'package:aura/network/api/countries/models/countries_response.dart';
import 'package:aura/network/requester.dart';

class CountriesApi extends ApiCore {
  CountriesApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<CountriesResponse>>> getCountries(
      {required CountriesRequest countriesRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.countriesEndpoint
          .getCountries(countriesRequest: countriesRequest),
    );

    final data = BaseResponse<CountriesResponse>.fromJson(
      response.response,
      (data) => CountriesResponse.fromJson(data ?? {}),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
