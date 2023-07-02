
import 'dart:convert';

import 'package:aura/network/response.dart';

class MeasurementData {
    final int? locationId;
    final String? location;
    final String? parameter;
    final double? value;
    final Date? date;
    final String? unit;
    final Coordinates? coordinates;
    final String? country;
    final dynamic city;
    final bool? isMobile;
    final dynamic isAnalysis;
    final String? entity;
    final String? sensorType;

    MeasurementData({
        this.locationId,
        this.location,
        this.parameter,
        this.value,
        this.date,
        this.unit,
        this.coordinates,
        this.country,
        this.city,
        this.isMobile,
        this.isAnalysis,
        this.entity,
        this.sensorType,
    });

    factory MeasurementData.fromRawJson(String str) => MeasurementData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MeasurementData.fromJson(Map<String, dynamic> json) => MeasurementData(
        locationId: json["locationId"],
        location: json["location"],
        parameter: json["parameter"],
        value: json["value"]?.toDouble(),
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
        unit: json["unit"],
        coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
        country: json["country"],
        city: json["city"],
        isMobile: json["isMobile"],
        isAnalysis: json["isAnalysis"],
        entity: json["entity"],
        sensorType: json["sensorType"],
    );

    Map<String, dynamic> toJson() => {
        "locationId": locationId,
        "location": location,
        "parameter": parameter,
        "value": value,
        "date": date?.toJson(),
        "unit": unit,
        "coordinates": coordinates?.toJson(),
        "country": country,
        "city": city,
        "isMobile": isMobile,
        "isAnalysis": isAnalysis,
        "entity": entity,
        "sensorType": sensorType,
    };
}
