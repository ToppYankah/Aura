import 'package:aura/network/api/api_core.dart';

class ApiEndpoint {
  Uri address;
  RequestType requestType;
  Map<String, String> headers;
  Map<String, dynamic> body;

  ApiEndpoint(
      {required this.address,
      required this.requestType,
      required this.headers,
      required this.body});
}

mixin EndpointCore {
  static const String authority = "api.openaq.org";

  Future<ApiEndpoint> createEndpoint({
    required authority,
    required String path,
    required RequestType requestType,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    Map<String, dynamic> requestBody = body ?? {};

    final queryParameters = requestType == RequestType.GET ? requestBody : null;

    final uri = Uri.https(authority, path,
        queryParameters?.map((key, value) => MapEntry(key, value.toString())));

    return ApiEndpoint(
      address: uri,
      body: requestBody,
      headers: requestHeaders,
      requestType: requestType,
    );
  }
}
