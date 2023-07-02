import 'dart:convert';

class ParameterData {
  final int? id;
  final String? name;
  final bool? isCore;
  final String? displayName;
  final String? description;
  final String? preferredUnit;
  final double? maxColorValue;
  static double fallbackMaxColorValue = 1000;

  ParameterData({
    this.id,
    this.name,
    this.displayName,
    this.description,
    this.preferredUnit,
    this.isCore,
    this.maxColorValue,
  });

  factory ParameterData.fromRawJson(String str) =>
      ParameterData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParameterData.fromJson(Map<String, dynamic> json) => ParameterData(
        id: json["id"],
        name: json["name"],
        displayName: json["displayName"],
        description: json["description"],
        preferredUnit: json["preferredUnit"],
        isCore: json["isCore"],
        maxColorValue: json["maxColorValue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "displayName": displayName,
        "description": description,
        "preferredUnit": preferredUnit,
        "isCore": isCore,
        "maxColorValue": maxColorValue,
      };
}
