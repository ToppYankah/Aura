import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/debouncer.dart';
import 'package:aura/network/api/countries/models/country_data.dart';
import 'package:aura/network/api/locations/models/location_data.dart';
import 'package:aura/providers/countries_provider.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/empty_list.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/location-selector/location_item.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationSelection extends StatefulWidget {
  final bool visible;
  final CountryData? fromCountry;
  final void Function(LocationData location) onLocationChange;

  const LocationSelection({
    super.key,
    this.fromCountry,
    this.visible = true,
    required this.onLocationChange,
  });

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  LocationData? _selected;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    // Get locations on widget build
    CommonUtils.performPostBuild(context, () {
      final provider = Provider.of<LocationProvider>(context, listen: false);

      // Fetch locations if provider's locations is empty
      if (provider.locations.isEmpty) _debouncer.run(_getLocations);

      // Set selected location to provider's selected location (incase != null)
      setState(() => _selected = provider.selectedLocation);
      if (provider.getLocationKey.currentContext != null) {
        Scrollable.ensureVisible(provider.getLocationKey.currentContext!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant LocationSelection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Get locations on widget update
    final countriesProvider =
        Provider.of<CountriesProvider>(context, listen: false);
    final locationsProvider =
        Provider.of<LocationProvider>(context, listen: false);

    if (locationsProvider.locations.isEmpty) {
      CommonUtils.performPostBuild(
          context, () => _debouncer.run(_getLocations));
      return;
    }

    if (countriesProvider.selectedCountry!.name == widget.fromCountry!.name &&
        countriesProvider.selectedCountry!.name !=
            (oldWidget.fromCountry?.name ?? "")) {
      return;
    }

    CommonUtils.performPostBuild(context, () => _debouncer.run(_getLocations));
  }

  void _getLocations() {
    final provider = Provider.of<LocationProvider>(context, listen: false);

    // Get locations if fromCountry has value
    if (widget.fromCountry != null) {
      provider.getCountryLocations(countryCode: widget.fromCountry!.code!);
    }
  }

  void _handleSelectLocation(LocationData location) {
    widget.onLocationChange(location);
    setState(() => _selected = location);
  }

  Widget _renderLocations({required List<LocationData> locations}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: locations
            .map(
              (data) => LocationItem(
                data: data,
                key: data.key,
                active: _selected?.id == data.id,
                onSelect: () => _handleSelectLocation(data),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !widget.visible
        ? const SizedBox()
        : Expanded(
            child: Consumer<LocationProvider>(
              builder: (context, provider, _) {
                return ThemeBuilder(builder: (theme, isDark) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10)
                        .copyWith(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Place",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theme.paragraphDeep,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (provider.isLoading) const AppLoader(),
                                  if (provider.locations.isNotEmpty)
                                    ClipSmoothRect(
                                      radius:
                                          SmoothBorderRadius(cornerRadius: 20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 10),
                                        color: theme.cardBackground,
                                        child: Text(
                                          "${provider.locations.length} found",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: theme.paragraph),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: DottedBorder(
                            strokeWidth: 1,
                            color: theme.border!,
                            dashPattern: const [5, 5],
                            strokeCap: StrokeCap.round,
                            borderType: BorderType.RRect,
                            padding: const EdgeInsets.all(10),
                            radius: const SmoothRadius(
                                cornerRadius: 30, cornerSmoothing: 0.8),
                            child: IgnorePointer(
                              ignoring: provider.isLoading,
                              child: Opacity(
                                opacity: provider.isLoading ? 0.5 : 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: provider.locations.isNotEmpty
                                      ? _renderLocations(
                                          locations: provider.locations)
                                      : EmptyList(
                                          disabled: provider.isLoading,
                                          message: "No locations found",
                                          onReload: () =>
                                              _debouncer.run(_getLocations),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
            ),
          );
  }
}
