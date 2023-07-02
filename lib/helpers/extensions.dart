import 'dart:convert';

extension MapExtensions on Map<String, dynamic> {
  String toJson() {
    return jsonEncode(this);
  }
}