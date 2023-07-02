import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppMarkers {
  late final BitmapDescriptor goodMarker;
  late final BitmapDescriptor moderateMarker;
  late final BitmapDescriptor unhealthySFGMarker;
  late final BitmapDescriptor unhealthyMarker;
  late final BitmapDescriptor veryUnhealthyMarker;
  late final BitmapDescriptor hazardousMarker;

  AppMarkers();

  Future<void> initialize(BuildContext context) async {
    List<BitmapDescriptor> result = await Future.wait<BitmapDescriptor>([
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.goodMarker),
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.moderateMarker),
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.unhealthySFGMarker),
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.unhealthyMarker),
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.veryUnhealthyMarker),
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), AppStringImages.hazardousMarker),
    ]);

    goodMarker = result[0];
    moderateMarker = result[1];
    unhealthySFGMarker = result[2];
    unhealthyMarker = result[3];
    veryUnhealthyMarker = result[4];
    hazardousMarker = result[5];
  }

  BitmapDescriptor getBitmapFromAQIStatus(AQIStatusType aqiStatus) {
    switch (aqiStatus) {
      case AQIStatusType.good:
        return goodMarker;
      case AQIStatusType.moderate:
        return moderateMarker;
      case AQIStatusType.unhealthySFG:
        return unhealthySFGMarker;
      case AQIStatusType.unhealthy:
        return unhealthyMarker;
      case AQIStatusType.veryUnhealthy:
        return veryUnhealthyMarker;
      default:
        return hazardousMarker;
    }
  }
}
