import 'dart:convert';

class CountryData {
    final String? code;
    final String? name;
    final int? locations;
    final DateTime? firstUpdated;
    final DateTime? lastUpdated;
    final List<String>? parameters;
    final int? count;
    final int? cities;
    final int? sources;

    CountryData({
        this.code,
        this.name,
        this.locations,
        this.firstUpdated,
        this.lastUpdated,
        this.parameters,
        this.count,
        this.cities,
        this.sources,
    });

    factory CountryData.fromRawJson(String str) => CountryData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        code: json["code"],
        name: json["name"],
        locations: json["locations"],
        firstUpdated: json["firstUpdated"] == null ? null : DateTime.parse(json["firstUpdated"]),
        lastUpdated: json["lastUpdated"] == null ? null : DateTime.parse(json["lastUpdated"]),
        parameters: json["parameters"] == null ? [] : List<String>.from(json["parameters"]!.map((x) => x)),
        count: json["count"],
        cities: json["cities"],
        sources: json["sources"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "locations": locations,
        "firstUpdated": firstUpdated?.toIso8601String(),
        "lastUpdated": lastUpdated?.toIso8601String(),
        "parameters": parameters == null ? [] : List<dynamic>.from(parameters!.map((x) => x)),
        "count": count,
        "cities": cities,
        "sources": sources,
    };
}
