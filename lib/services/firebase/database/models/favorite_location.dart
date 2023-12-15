import 'package:aura/network/api/api_core.dart';

class FavoriteLocation implements Serializable {
  final int locationId;
  final String country, userEmail, locationName;

  FavoriteLocation({
    required this.country,
    required this.userEmail,
    required this.locationId,
    required this.locationName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "userEmail": userEmail,
      "locationId": locationId,
      "locationName": locationName,
    };
  }

  factory FavoriteLocation.fromJson(Map<String, dynamic> json) {
    return FavoriteLocation(
      country: json["country"],
      userEmail: json["userEmail"],
      locationId: json["locationId"],
      locationName: json["locationName"],
    );
  }
}
