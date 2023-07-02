
import 'dart:convert';

class CityData {
  final String? country;
  final String? city;
  final int? count;
  final int? locations;
  final DateTime? firstUpdated;
  final DateTime? lastUpdated;
  final List<String>? parameters;

  CityData({
    this.country,
    this.city,
    this.count,
    this.locations,
    this.firstUpdated,
    this.lastUpdated,
    this.parameters,
  });

  factory CityData.fromRawJson(String str) =>
      CityData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        country: json["country"],
        city: json["city"],
        count: json["count"],
        locations: json["locations"],
        firstUpdated: json["firstUpdated"] == null
            ? null
            : DateTime.parse(json["firstUpdated"]),
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
        parameters: json["parameters"] == null
            ? []
            : List<String>.from(json["parameters"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "city": city,
        "count": count,
        "locations": locations,
        "firstUpdated": firstUpdated?.toIso8601String(),
        "lastUpdated": lastUpdated?.toIso8601String(),
        "parameters": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x)),
      };
}
