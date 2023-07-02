import 'dart:convert';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/measurements/models/measurement_data.dart';
import 'package:aura/network/response.dart';

class MeasurementsResponse implements Serializable {
  final Meta? meta;
  final List<MeasurementData>? results;

  MeasurementsResponse({
    this.meta,
    this.results,
  });

  factory MeasurementsResponse.fromRawJson(String str) =>
      MeasurementsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeasurementsResponse.fromJson(Map<String, dynamic>? json) =>
      MeasurementsResponse(
        meta: json?["meta"] == null ? null : Meta.fromJson(json?["meta"]),
        results: json?["results"] == null
            ? []
            : List<MeasurementData>.from(
                json?["results"]!.map((x) => MeasurementData.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
