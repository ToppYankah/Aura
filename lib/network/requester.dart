import 'dart:convert';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/network/response.dart';
import 'package:http/http.dart' as http;
import 'package:aura/helpers/extensions.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/endpoint_core.dart';

class Requester {
  late http.Response _response;

  Future<Response> makeRequest(
      {required Future<ApiEndpoint> apiEndpoint}) async {
    try {
      final endpoint = await apiEndpoint;

      // Log request data for debugging
      AppLogger.logGroup([
        LogItem(title: "Type", data: {"type": endpoint.requestType.toString()}),
        LogItem(title: "Addresss", data: {"URL": endpoint.address}),
        LogItem(title: "Params", data: endpoint.body),
        LogItem(title: "Headers", data: endpoint.headers),
      ], "Request Log");

      switch (endpoint.requestType) {
        case RequestType.GET:
          _response =
              await http.get(endpoint.address, headers: endpoint.headers);
          break;

        case RequestType.POST:
          _response = await http.post(endpoint.address,
              headers: endpoint.headers, body: endpoint.body.toJson());
          break;

        case RequestType.DELETE:
          _response = await http.delete(endpoint.address,
              headers: endpoint.headers, body: endpoint.body.toJson());
          break;
        case RequestType.PUT:
          _response = await http.put(endpoint.address,
              headers: endpoint.headers, body: endpoint.body.toJson());
          break;
        case RequestType.PATCH:
          _response = await http.patch(endpoint.address,
              headers: endpoint.headers, body: endpoint.body.toJson());
          break;
      }

      var jsonResponse = jsonDecode(_response.body);

      if (_response.statusCode >= 200 && _response.statusCode <= 300) {
        return Response(
            responseStatus: ResponseStatus.successful,
            response: jsonResponse,
            rawResponse: _response.body);
      } else {
        return Response(
          responseStatus: ResponseStatus.error,
          error: ErrorResponse.fromJson(jsonResponse),
        );
      }
    } catch (e) {
      return Response(responseStatus: ResponseStatus.failed);
    }
  }
}
