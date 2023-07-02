import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/countries/models/countries_request.dart';
import 'package:aura/network/api/endpoint_core.dart';

class CountriesEndpoint with EndpointCore {
  Future<ApiEndpoint> getCountries(
      {required CountriesRequest countriesRequest}) async {
    return await createEndpoint(
      path: '/v2/countries',
      requestType: RequestType.GET,
      body: countriesRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }

  Future<ApiEndpoint> getCountryById(
      {required CountriesRequest countriesRequest, required int id}) async {
    return await createEndpoint(
      path: '/v2/countries/$id',
      requestType: RequestType.GET,
      body: countriesRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }
}
