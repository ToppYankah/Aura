import 'package:aura/providers/theme_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ReadingMap extends StatefulWidget {
  final Set<Marker> markers;
  final bool showUserPosition;
  final CameraPosition initialCameraPosition;
  final void Function(GoogleMapController controller) onMapCreated;
  const ReadingMap({
    super.key,
    this.markers = const {},
    required this.onMapCreated,
    this.showUserPosition = false,
    required this.initialCameraPosition,
  });

  @override
  State<ReadingMap> createState() => _ReadingMapState();
}

class _ReadingMapState extends State<ReadingMap> {
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final isDark = themeProvider.currentThemeEnum == ThemeEnum.dark;
      final filePath =
          isDark ? FileRoots.darkMapStyle : FileRoots.lightMapStyle;

      rootBundle.loadString(filePath).then((string) => _mapStyle = string);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      compassEnabled: false,
      mapType: MapType.normal,
      markers: widget.markers,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: widget.showUserPosition,
      initialCameraPosition: widget.initialCameraPosition,
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 120),
      onMapCreated: (GoogleMapController controller) {
        widget.onMapCreated(controller);
        if (_mapStyle != null) {
          controller.setMapStyle(_mapStyle);
        }
      },
    );
  }
}
