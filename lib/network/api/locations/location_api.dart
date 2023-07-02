import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/locations/models/locations_request.dart';
import 'package:aura/network/api/locations/models/locations_response.dart';
import 'package:aura/network/requester.dart';

class LocationsApi extends ApiCore {
  LocationsApi({required Requester requester}) : super(requester: requester);

  Future<ApiResponse<BaseResponse<LocationsResponse>>> getLocationById(int id,
      {required LocationsRequest locationsRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.locationsEndpoint.getLocationById(
        id: id,
        locationsRequest: locationsRequest,
      ),
    );

    final data = BaseResponse<LocationsResponse>(
      data: await CommonUtils.getResponseInBackground<LocationsResponse>(
        response.response,
        LocationsResponse.fromJson,
        orElse: () => LocationsResponse(),
      ),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }

  Future<ApiResponse<BaseResponse<LocationsResponse>>> getLocations(
      {required LocationsRequest locationsRequest}) async {
    final response = await requester.makeRequest(
      apiEndpoint: endpoints.locationsEndpoint
          .getLocations(locationsRequest: locationsRequest),
    );

    final data = BaseResponse<LocationsResponse>(
      data: await CommonUtils.getResponseInBackground<LocationsResponse>(
        response.response,
        LocationsResponse.fromJson,
        orElse: () => LocationsResponse(),
      ),
    );

    return ApiResponse(response: data, status: response.responseStatus);
  }
}
