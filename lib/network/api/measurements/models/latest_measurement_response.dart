import 'dart:convert';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/network/response.dart';
import 'package:aura/network/api/api_core.dart';

class LatestMeasurementsResponse implements Serializable {
  final Meta? meta;
  final List<LatestMeasurementData>? results;

  LatestMeasurementsResponse({
    this.meta,
    this.results,
  });

  factory LatestMeasurementsResponse.fromRawJson(String str) =>
      LatestMeasurementsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMeasurementsResponse.fromJson(Map<String, dynamic>? json) =>
      LatestMeasurementsResponse(
        meta: json?["meta"] == null ? null : Meta.fromJson(json?["meta"]),
        results: json?["results"] == null
            ? []
            : List<LatestMeasurementData>.from(json?["results"]!
                .map((x) => LatestMeasurementData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}
