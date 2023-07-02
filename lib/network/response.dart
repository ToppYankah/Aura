import 'dart:convert';

import 'package:aura/network/api/api_core.dart';

class Response {
  dynamic response;
  String? rawResponse;
  ErrorResponse? error;
  ResponseStatus? responseStatus;

  Response({
    this.responseStatus,
    this.response,
    this.rawResponse,
    this.error,
  });
}

class ErrorResponse {
  final List<ErrorDetail>? detail;

  ErrorResponse({
    this.detail,
  });

  factory ErrorResponse.fromRawJson(String str) =>
      ErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        detail: json["detail"] == null
            ? []
            : List<ErrorDetail>.from(
                json["detail"]!.map((x) => ErrorDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detail": detail == null
            ? []
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class ErrorDetail {
  final List<String>? loc;
  final String? msg;
  final String? type;

  ErrorDetail({
    this.loc,
    this.msg,
    this.type,
  });

  factory ErrorDetail.fromRawJson(String str) =>
      ErrorDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorDetail.fromJson(Map<String, dynamic> json) => ErrorDetail(
        loc: json["loc"] == null
            ? []
            : List<String>.from(json["loc"]!.map((x) => x)),
        msg: json["msg"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "loc": loc == null ? [] : List<dynamic>.from(loc!.map((x) => x)),
        "msg": msg,
        "type": type,
      };
}

class Meta {
  final String? name;
  final String? license;
  final String? website;
  final int? page;
  final int? limit;
  final String? found;

  Meta({
    this.name,
    this.license,
    this.website,
    this.page,
    this.limit,
    this.found,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        name: json["name"],
        license: json["license"],
        website: json["website"],
        page: json["page"],
        limit: json["limit"],
        found: json["found"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "license": license,
        "website": website,
        "page": page,
        "limit": limit,
        "found": found.toString(),
      };
}

class FutureResponse<T> {
  final T? data;
  final String? error;

  FutureResponse({this.data, this.error});
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  factory Coordinates.fromRawJson(String str) =>
      Coordinates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Date {
  final DateTime? utc;
  final DateTime? local;

  Date({
    this.utc,
    this.local,
  });

  factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        utc: json["utc"] == null ? null : DateTime.parse(json["utc"]),
        local: json["local"] == null ? null : DateTime.parse(json["local"]),
      );

  Map<String, dynamic> toJson() => {
        "utc": utc?.toIso8601String(),
        "local": local?.toIso8601String(),
      };
}
