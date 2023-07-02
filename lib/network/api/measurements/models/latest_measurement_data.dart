import 'dart:convert';

import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/response.dart';

class LatestMeasurementData implements Serializable {
  final String? location;
  final dynamic city;
  final String? country;
  final Coordinates? coordinates;
  final List<SimpleMeasurementData>? measurements;

  LatestMeasurementData({
    this.location,
    this.city,
    this.country,
    this.coordinates,
    this.measurements,
  });

  factory LatestMeasurementData.fromRawJson(String str) =>
      LatestMeasurementData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMeasurementData.fromJson(Map<String, dynamic> json) =>
      LatestMeasurementData(
        location: json["location"],
        city: json["city"],
        country: json["country"],
        coordinates: json["coordinates"] == null
            ? null
            : Coordinates.fromJson(json["coordinates"]),
        measurements: json["measurements"] == null
            ? []
            : List<SimpleMeasurementData>.from(json["measurements"]!
                .map((x) => SimpleMeasurementData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "city": city,
        "country": country,
        "coordinates": coordinates?.toJson(),
        "measurements": measurements == null
            ? []
            : List<dynamic>.from(measurements!.map((x) => x.toJson())),
      };
}

class SimpleMeasurementData {
  final String? parameter;
  final double? value;
  final DateTime? lastUpdated;
  final String? unit;

  SimpleMeasurementData({
    this.parameter,
    this.value,
    this.lastUpdated,
    this.unit,
  });

  factory SimpleMeasurementData.fromRawJson(String str) =>
      SimpleMeasurementData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimpleMeasurementData.fromJson(Map<String, dynamic> json) =>
      SimpleMeasurementData(
        parameter: json["parameter"],
        value: json["value"],
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "parameter": parameter,
        "value": value,
        "lastUpdated": lastUpdated?.toIso8601String(),
        "unit": unit,
      };
}
