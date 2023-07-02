import 'dart:convert';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/parameters/models/parameter_data.dart';
import 'package:aura/network/response.dart';

class ParametersResponse implements Serializable {
  final Meta? meta;
  final List<ParameterData>? results;

  ParametersResponse({
    this.meta,
    this.results,
  });

  factory ParametersResponse.fromRawJson(String str) =>
      ParametersResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParametersResponse.fromJson(Map<String, dynamic>? json) =>
      ParametersResponse(
        meta: json?["meta"] == null ? null : Meta.fromJson(json?["meta"]),
        results: json?["results"] == null
            ? []
            : List<ParameterData>.from(
                json?["results"]!.map((x) => ParameterData.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
