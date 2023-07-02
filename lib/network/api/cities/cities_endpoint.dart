import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/cities/models/cities_request.dart';
import 'package:aura/network/api/endpoint_core.dart';

class CitiesEndpoint with EndpointCore {
  Future<ApiEndpoint> getCities({required CitiesRequest citiesRequest}) async {
    return await createEndpoint(
      path: '/v2/cities',
      requestType: RequestType.GET,
      body: citiesRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }
}
