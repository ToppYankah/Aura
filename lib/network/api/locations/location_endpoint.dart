import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/endpoint_core.dart';
import 'package:aura/network/api/locations/models/locations_request.dart';

class LocationsEndpoint with EndpointCore {
  Future<ApiEndpoint> getLocations(
      {required LocationsRequest locationsRequest}) async {
    return await createEndpoint(
      path: '/v2/locations',
      requestType: RequestType.GET,
      body: locationsRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }

  Future<ApiEndpoint> getLocationById(
      {required LocationsRequest locationsRequest, required int id}) async {
    return await createEndpoint(
      path: '/v2/locations/$id',
      requestType: RequestType.GET,
      body: locationsRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }
}
