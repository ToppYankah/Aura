
import 'dart:convert';

class LocationSource {
  final String? url;
  final String? name;
  final String? id;
  final dynamic readme;
  final dynamic organization;
  final dynamic lifecycleStage;

  LocationSource({
    this.url,
    this.name,
    this.id,
    this.readme,
    this.organization,
    this.lifecycleStage,
  });

  factory LocationSource.fromRawJson(String str) => LocationSource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationSource.fromJson(Map<String, dynamic> json) => LocationSource(
        url: json["url"],
        name: json["name"],
        id: json["id"],
        readme: json["readme"],
        organization: json["organization"],
        lifecycleStage: json["lifecycle_stage"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "name": name,
        "id": id,
        "readme": readme,
        "organization": organization,
        "lifecycle_stage": lifecycleStage,
      };
}
