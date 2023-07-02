import 'dart:convert';
import 'package:aura/network/api/locations/models/location_data.dart';
import 'package:aura/network/response.dart';
import 'package:aura/network/api/api_core.dart';

class LocationsResponse implements Serializable {
  final Meta? meta;
  final List<LocationData>? results;

  LocationsResponse({
    this.meta,
    this.results,
  });

  factory LocationsResponse.fromRawJson(String str) =>
      LocationsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationsResponse.fromJson(Map<String, dynamic>? json) =>
      LocationsResponse(
        meta: json?["meta"] == null ? null : Meta.fromJson(json?["meta"]),
        results: json?["results"] == null
            ? []
            : List<LocationData>.from(
                json?["results"]!.map((x) => LocationData.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
