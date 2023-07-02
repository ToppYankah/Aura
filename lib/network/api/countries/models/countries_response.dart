import 'dart:convert';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/countries/models/country_data.dart';
import 'package:aura/network/response.dart';

class CountriesResponse implements Serializable {
  final Meta? meta;
  final List<CountryData>? results;

  CountriesResponse({
    this.meta,
    this.results,
  });

  factory CountriesResponse.fromRawJson(String str) =>
      CountriesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountriesResponse.fromJson(Map<String, dynamic> json) =>
      CountriesResponse(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        results: json["results"] == null
            ? []
            : List<CountryData>.from(
                json["results"]!.map((x) => CountryData.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
