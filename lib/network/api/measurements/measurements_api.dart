import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_response.dart';
import 'package:aura/network/api/measurements/models/measurements_request.dart';
import 'package:aura/network/api/measurements/models/measurements_response.dart';
import 'package:aura/network/requester.dart';

class MeasurementsApi extends ApiCore {
  MeasurementsApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<MeasurementsResponse>>> getMeasurements(
      {required MeasurementsRequest measurementsRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.measurementsEndpoint
          .getMeasurements(measurementsRequest: measurementsRequest),
    );

    final data = BaseResponse<MeasurementsResponse>(
      data: await CommonUtils.getResponseInBackground<MeasurementsResponse>(
        response.response,
        MeasurementsResponse.fromJson,
        orElse: () => MeasurementsResponse(),
      ),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }

  Future<ApiResponse<BaseResponse<LatestMeasurementsResponse>>>
      getLatestMeasurements(
          {required MeasurementsRequest latestMeasurementsRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.measurementsEndpoint.getLatestMeasurements(
        latestMeasurementsRequest: latestMeasurementsRequest,
      ),
    );

    final data = BaseResponse<LatestMeasurementsResponse>.fromJson(
      response.response,
      (data) => LatestMeasurementsResponse.fromJson(data),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }

  Future<ApiResponse<BaseResponse<LatestMeasurementsResponse>>>
      getLatestMeasurementsByLocationId(
          {required MeasurementsRequest latestMeasurementsRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint:
          endpoints.measurementsEndpoint.getLatestMeasurementsByLocationId(
        latestMeasurementsRequest: latestMeasurementsRequest,
      ),
    );

    final data = BaseResponse<LatestMeasurementsResponse>.fromJson(
      response.response,
      (data) => LatestMeasurementsResponse.fromJson(data),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
