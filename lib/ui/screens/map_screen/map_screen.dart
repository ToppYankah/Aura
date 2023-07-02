import 'dart:async';
import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/network/response.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_markers.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/map_screen/widgets/location_measurement_detail.dart';
import 'package:aura/ui/screens/map_screen/widgets/range_indicator.dart';
import 'package:aura/ui/screens/map_screen/widgets/reading_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _initialPosition;
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _getInitialCameraPosition();
  }

  void _getInitialCameraPosition() {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final Coordinates coords = provider.selectedLocation!.coordinates!;

    _initialPosition =
        CameraPosition(target: LatLng(coords.latitude!, coords.longitude!));
  }

  Future<Set<Marker>> _generateMapMarkers(
      List<LatestMeasurementData> data) async {
    // Fetch custom markers
    final AppMarkers markers = AppMarkers();
    await markers.initialize(context);

    // start running background heavy task in isolate
    final output = await CommonUtils.runIsolateTask<List, Set<Marker>>(
      _convertLocationsIntoMarkers,
      args: [markers, data],
    );

    return output ?? {};
  }

  static Set<Marker> _convertLocationsIntoMarkers(List? args) {
    Set<Marker> output = {};
    if (args == null) return output;

    final AppMarkers markers = args[0];
    final List<LatestMeasurementData> measurements = args[1];

    for (var measure in measurements) {
      final parameter = measure.measurements!
          .singleWhere((element) => element.parameter == "pm25");
      final AQIDetails aqi = AQIUtil.getAQIValue(parameter.value!);
      late BitmapDescriptor bitmap =
          markers.getBitmapFromAQIStatus(aqi.status.type);

      output.add(
        Marker(
          icon: bitmap,
          position: LatLng(
            measure.coordinates!.latitude!,
            measure.coordinates!.longitude!,
          ),
          markerId: MarkerId(measure.location ?? "Unknown Location"),
        ),
      );
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        final measurementsProvider =
            Provider.of<MeasurementsProvider>(context, listen: false);
        return FutureBuilder(
          future: measurementsProvider.getMapMeasurements(),
          builder: (context, mapSnapshot) {
            final bool locationsLoading =
                mapSnapshot.connectionState == ConnectionState.waiting;
            return Stack(
              children: [
                FutureBuilder(
                  future: _generateMapMarkers(mapSnapshot.data ?? []),
                  builder: (context, markerSnapShot) {
                    return ReadingMap(
                      markers: markerSnapShot.data ?? {},
                      initialCameraPosition: _initialPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: AppIconButton(
                              icon: IconlyBold.arrow_left_3,
                              onTap: () => Navigation.back(context: context),
                              iconColor: isDark ? theme.paragraphDeep : null,
                              background: isDark ? theme.background : null,
                            ),
                          ),
                          Expanded(
                            child: AppTextField(
                              applyMargin: false,
                              applyPadding: false,
                              icon: IconlyLight.search,
                              placeholder: "Search location",
                              background: isDark ? theme.background : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: AppIconButton(
                              icon: Iconsax.refresh,
                              disabled: locationsLoading,
                              onTap: () => setState(() {}),
                              iconColor: isDark ? theme.paragraphDeep : null,
                              background: isDark ? theme.background : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const LocationDetailsSlider()
              ],
            );
          },
        );
      },
    );
  }
}

class LocationDetailsSlider extends StatelessWidget {
  final LatestMeasurementData? data;
  const LocationDetailsSlider({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ThemeBuilder(builder: (theme, isDark) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LocationMeasurementDetails(),
            RangeIndicator(),
          ],
        );
      }),
    );
  }
}
