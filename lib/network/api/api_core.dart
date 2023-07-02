import 'package:aura/network/endpoints.dart';
import 'package:aura/network/requester.dart';
import 'package:aura/network/response.dart';

enum ResponseStatus { successful, failed, noInternet, loading, error }

// ignore: constant_identifier_names
enum RequestType { POST, GET, PUT, PATCH, DELETE }

abstract class Serializable {
  Map<String, dynamic> toJson();
}

// TODO: Base response models to be implemented

class ApiResponse<T extends Serializable> implements Serializable {
  T? response;
  ErrorResponse? error;
  ResponseStatus? status;

  ApiResponse({this.response, this.status, this.error});

  @override
  Map<String, dynamic> toJson() {
    return {
      "response": response?.toJson(),
      "status": status,
      "error": error?.toJson(),
    };
  }
}

// class BaseResponse<T extends Serializable> implements Serializable {
//   String? code = "";
//   T? data;
//   String? message;
//
//   BaseResponse({this.code, this.data, this.message});
//
//   factory BaseResponse.fromJson(Map<String, dynamic>? json, Function(Map<String, dynamic>?) create) {
//     return BaseResponse(
//         code: json?['code'], data: create(json?["data"]), message: json?['message'],);
//   }
//
//   @override
//   Map<String, dynamic> toMap() => {
//     "code": this.code,
//     "message": this.message,
//     "data": this.data?.toMap(),
//   };
// }

class BaseResponse<T extends Serializable> implements Serializable {
  T? data;

  BaseResponse({this.data});

  factory BaseResponse.fromJson(
      Map<String, dynamic>? json, Function(Map<String, dynamic>?) create) {
    return BaseResponse(
      data: create(json),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "data": this.data?.toJson(),
      };
}

class ApiCore {
  EndpointCollection endpoints = EndpointCollection();

  Requester requester;

  ApiCore({required this.requester});
}
