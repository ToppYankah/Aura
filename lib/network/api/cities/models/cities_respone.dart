import 'dart:convert';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/cities/models/city_data.dart';
import 'package:aura/network/response.dart';

class CitiesResponse implements Serializable {
  final Meta? meta;
  final List<CityData>? results;

  CitiesResponse({
    this.meta,
    this.results,
  });

  factory CitiesResponse.fromRawJson(String str) =>
      CitiesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CitiesResponse.fromJson(Map<String, dynamic> json) => CitiesResponse(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        results: json["results"] == null
            ? []
            : List<CityData>.from(
                json["results"]!.map((x) => CityData.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
