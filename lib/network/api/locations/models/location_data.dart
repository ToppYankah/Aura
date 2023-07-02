import 'dart:convert';

import 'package:aura/network/api/locations/models/location_parameter.dart';
import 'package:aura/network/api/locations/models/location_source.dart';
import 'package:aura/network/response.dart';
import 'package:flutter/material.dart';

class LocationData {
  final int? id;
  final dynamic city;
  final String? name;
  final String? entity;
  final String? country;
  final bool? isMobile;
  final bool? isAnalysis;
  final List<LocationSource>? sources;
  final List<LocationParameter>? parameters;
  final String? sensorType;
  final Coordinates? coordinates;
  final DateTime? lastUpdated;
  final DateTime? firstUpdated;
  final int? measurements;
  final dynamic bounds;
  final dynamic manufacturers;
  final GlobalKey? key;

  LocationData({
    this.id,
    this.city,
    this.name,
    this.entity,
    this.country,
    this.sources,
    this.isMobile,
    this.isAnalysis,
    this.parameters,
    this.sensorType,
    this.coordinates,
    this.lastUpdated,
    this.firstUpdated,
    this.measurements,
    this.bounds,
    this.manufacturers,
    this.key,
  });

  factory LocationData.fromRawJson(String str) =>
      LocationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        id: json["id"],
        key: GlobalKey(),
        city: json["city"],
        name: json["name"],
        entity: json["entity"],
        country: json["country"],
        sources: json["sources"] == null
            ? []
            : List<LocationSource>.from(
                json["sources"]!.map((x) => LocationSource.fromJson(x))),
        isMobile: json["isMobile"],
        isAnalysis: json["isAnalysis"],
        parameters: json["parameters"] == null
            ? []
            : List<LocationParameter>.from(
                json["parameters"]!.map((x) => LocationParameter.fromJson(x))),
        sensorType: json["sensorType"],
        coordinates: json["coordinates"] == null
            ? null
            : Coordinates.fromJson(json["coordinates"]),
        lastUpdated: json["lastUpdated"] == null
            ? null
            : DateTime.parse(json["lastUpdated"]),
        firstUpdated: json["firstUpdated"] == null
            ? null
            : DateTime.parse(json["firstUpdated"]),
        measurements: json["measurements"],
        bounds: json["bounds"],
        manufacturers: json["manufacturers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "name": name,
        "entity": entity,
        "country": country,
        "sources": sources == null
            ? []
            : List<dynamic>.from(sources!.map((x) => x.toJson())),
        "isMobile": isMobile,
        "isAnalysis": isAnalysis,
        "parameters": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x.toJson())),
        "sensorType": sensorType,
        "coordinates": coordinates?.toJson(),
        "lastUpdated": lastUpdated?.toIso8601String(),
        "firstUpdated": firstUpdated?.toIso8601String(),
        "measurements": measurements,
        "bounds": bounds,
        "manufacturers": manufacturers,
      };
}
