import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/endpoint_core.dart';
import 'package:aura/network/api/parameters/models/parameters_request.dart';

class ParametersEndpoint with EndpointCore {
  Future<ApiEndpoint> getParameters(
      {required ParametersRequest parametersRequest}) async {
    return await createEndpoint(
      path: '/v2/parameters',
      requestType: RequestType.GET,
      body: parametersRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }
}
