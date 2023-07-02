import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/endpoint_core.dart';
import 'package:aura/network/api/measurements/models/measurements_request.dart';

class MeasurementsEndpoint with EndpointCore {
  Future<ApiEndpoint> getMeasurements(
      {required MeasurementsRequest measurementsRequest}) async {
    return await createEndpoint(
      path: '/v2/measurements',
      requestType: RequestType.GET,
      body: measurementsRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }

  Future<ApiEndpoint> getLatestMeasurements(
      {required MeasurementsRequest latestMeasurementsRequest}) async {
    return await createEndpoint(
      path: '/v2/latest',
      requestType: RequestType.GET,
      body: latestMeasurementsRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }

  Future<ApiEndpoint> getLatestMeasurementsByLocationId(
      {required MeasurementsRequest latestMeasurementsRequest}) async {
    return await createEndpoint(
      path: '/v2/latest/${latestMeasurementsRequest.locationId}',
      requestType: RequestType.GET,
      body: latestMeasurementsRequest.toJson(),
      authority: EndpointCore.authority,
    );
  }
}
