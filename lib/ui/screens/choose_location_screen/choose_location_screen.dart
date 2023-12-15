import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/app_tutorial.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/countries/models/country_data.dart';
import 'package:aura/network/api/locations/models/location_data.dart';
import 'package:aura/providers/countries_provider.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/screens/choose_location_screen/tutorial/location_search_tutorial.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/location-selector/location_selection.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/country_carousel/country_carousel.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  // Write state variables here ----
  String? _searchValue;
  CountryData? _selectedCountry;
  LocationData? _selectedLocation;
  final _searchButtonKey = GlobalKey();
  final FocusNode _searchFocus = FocusNode();
  final AppTutorial _tutorial = AppTutorial();
  final SwiperController _carouselController = SwiperController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tutorial.initialize(_getTutorialItems());
    _tutorial.showTutorial(
      context,
      viewChekcker: PreferenceKeys.CHOOSE_LOCATION_TUTORIAL,
    );
    
    CommonUtils.performPostBuild(
      context,
      Provider.of<LocationProvider>(context, listen: false)
          .getUserCurrentLocation,
    );
  }

//  Country search handler ------
  void _handleSearch() {
    _searchController.clear();
    _searchFocus.requestFocus();
  }

//  Country search cancel handler -------
  void _handleCancelSearch() {
    _searchFocus.unfocus();
    _searchController.clear();
    setState(() => _searchValue = null);
  }

  void _handleSubmit() {
    if (_selectedLocation != null) {
      // Set values [Country &  Location] to respective providers
      Provider.of<CountriesProvider>(context, listen: false).countryValue =
          _selectedCountry!;
      Provider.of<LocationProvider>(context, listen: false).locationValue =
          _selectedLocation!;

      // Save location as reference to measurements provider
      CommonUtils.saveLocationAsReferenceForMeasurement(context);

      // Navigate to homescreen
      Navigation.openHomeScreen(context, const NavigationParams(replace: true));
    }
  }

  @override
  void dispose() {
    // Dispose all disposable state variables ----
    _searchFocus.dispose();
    _searchController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) => Stack(
        children: [
          // Hidden search input field -----
          Opacity(
            opacity: 0,
            child: IgnorePointer(
              ignoring: true,
              child: TextField(
                focusNode: _searchFocus,
                controller: _searchController,
                onEditingComplete: _handleCancelSearch,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => setState(() => _searchValue = value),
              ),
            ),
          ),
          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    bottom: false,
                    child: AppHeader(
                      title: "Choose Location",
                      onBack: () => Navigation.back(context: context),
                      trailing: KeyboardVisibilityBuilder(
                        builder: (context, isVisible) {
                          return AppIconButton(
                            key: _searchButtonKey,
                            icon: isVisible ? Icons.close : Icons.search,
                            onTap:
                                isVisible ? _handleCancelSearch : _handleSearch,
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CountryCarousel(
                          searchValue: _searchValue,
                          controller: _carouselController,
                          onSearchDone: _handleCancelSearch,
                          onCountryChange: (country) =>
                              CommonUtils.performPostBuild(
                            context,
                            () => setState(() => _selectedCountry = country),
                          ),
                        ),
                        Consumer<CountriesProvider>(
                            builder: (context, provider, _) {
                          return LocationSelection(
                            visible: !isKeyboardVisible,
                            fromCountry: _selectedCountry,
                            onLocationChange: (location) =>
                                CommonUtils.performPostBuild(
                              context,
                              () =>
                                  setState(() => _selectedLocation = location),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  if (!isKeyboardVisible)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: AppSlideButton(
                              onSubmit: _handleSubmit,
                              disabled: _selectedLocation == null,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<TutorialItem> _getTutorialItems() {
    return [
      TutorialItem(
        key: _searchButtonKey,
        identifier: "Search Button",
        widget: const LocationSearchTutorial(),
      ),
    ];
  }
}
