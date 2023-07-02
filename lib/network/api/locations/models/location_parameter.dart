
import 'dart:convert';

class LocationParameter {
  final int? id;
  final String? unit;
  final int? count;
  final double? average;
  final double? lastValue;
  final String? parameter;
  final String? displayName;
  final DateTime? lastUpdated;
  final int? parameterId;
  final DateTime? firstUpdated;
  final dynamic manufacturers;

  LocationParameter({
    this.id,
    this.unit,
    this.count,
    this.average,
    this.lastValue,
    this.parameter,
    this.displayName,
    this.lastUpdated,
    this.parameterId,
    this.firstUpdated,
    this.manufacturers,
  });

  factory LocationParameter.fromRawJson(String str) =>
      LocationParameter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationParameter.fromJson(Map<String, dynamic> json) => LocationParameter(
        id: json["id"],
        unit: json["unit"],
        count: json["count"],
        average: json["average"]?.toDouble(),
        lastValue: json["lastValue"]?.toDouble(),
        parameter: json["parameter"],
        displayName: json["displayName"],
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
        parameterId: json["parameterId"],
        firstUpdated: json["firstUpdated"] == null
            ? null
            : DateTime.parse(json["firstUpdated"]),
        manufacturers: json["manufacturers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit": unit,
        "count": count,
        "average": average,
        "lastValue": lastValue,
        "parameter": parameter,
        "displayName": displayName,
        "lastUpdated": lastUpdated?.toIso8601String(),
        "parameterId": parameterId,
        "firstUpdated": firstUpdated?.toIso8601String(),
        "manufacturers": manufacturers,
      };
}
