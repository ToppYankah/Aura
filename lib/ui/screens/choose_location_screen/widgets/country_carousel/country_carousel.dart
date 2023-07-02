import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/countries/models/country_data.dart';
import 'package:aura/providers/countries_provider.dart';
import 'package:aura/ui/screens/choose_location_screen/data/location_data.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/country_carousel/country_carousel_display.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/country_carousel/country_carousel_header.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/country_carousel/country_carousel_ring.dart';
import 'package:aura/ui/screens/choose_location_screen/widgets/country_carousel/country_item.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryCarousel extends StatefulWidget {
  final String? searchValue;
  final VoidCallback onSearchDone;
  final SwiperController controller;
  final void Function(CountryData country) onCountryChange;

  const CountryCarousel({
    super.key,
    this.searchValue,
    required this.controller,
    required this.onSearchDone,
    required this.onCountryChange,
  });

  @override
  State<CountryCarousel> createState() => _CountryCarouselState();
}

class _CountryCarouselState extends State<CountryCarousel> {
  CountryData? _currentCountry;
  SearchResult<CountryData>? _suggestedCountry;

  @override
  void initState() {
    super.initState();
    CommonUtils.performPostBuild(context, () async {
      // Fetch countries on screen load done ------
      final provider = Provider.of<CountriesProvider>(context, listen: false);
      await provider.getCountries();

      // Check if a country is already selected
      setState(() => _currentCountry = provider.selectedCountry);
      if (provider.selectedCountry != null && mounted) {
        // Move selected country into view
        widget.controller.move(
          provider.findCountry(provider.selectedCountry!.name!)!.index,
        );
      } else {
        // Move first country into view
        _chooseCountryAt(index: 0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CountryCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final provider = Provider.of<CountriesProvider>(context, listen: false);
    // Check if search value is not null
    if (widget.searchValue != null) {
      // Save country that match to suggestedCountry
      return setState(
        () => _suggestedCountry = provider.findCountry(widget.searchValue!),
      );
    }

    _handleSearchDone();
  }

  void _handleSearchDone({bool force = false}) {
    setState(() {
      // Check if suggestedCountry has non-null value
      if (_suggestedCountry != null) {
        // Assign suggested country to _currentCountry
        _currentCountry = _suggestedCountry!.data;
        // Send country feedback to parent widget
        widget.onCountryChange(_suggestedCountry!.data);
        // Auto-Swipe to newly assigned current country
        mounted
            ? widget.controller.move(_suggestedCountry!.index, animation: true)
            : null;
      }

      // reset _suggestedCountry value to null
      _suggestedCountry = null;
    });

    if (force) widget.onSearchDone();
  }

  void _chooseCountryAt({required int index}) {
    final provider = Provider.of<CountriesProvider>(context, listen: false);
    // check if there are countries
    if (provider.countries.isNotEmpty) {
      // Find country by index then save
      final CountryData country = provider.countries[index];
      setState(() => _currentCountry = country);
      // Send country feedback to parent widget
      widget.onCountryChange(country);
      // send feedback to provider
      // provider.countryValue = country;
    }
  }

  @override
  Widget build(BuildContext context) {
    const viewRatio = 0.45;
    final viewHeight = MediaQuery.of(context).size.width * viewRatio;

    return Consumer<CountriesProvider>(
      builder: (context, data, _) {
        final int total = data.countries.length;
        final int page = data.countries.indexOf(_currentCountry) + 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselHeader(
              showPagination: data.countries.isNotEmpty,
              pagination: CarouselPagination(page: page, total: total),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: viewHeight,
              child: Stack(
                children: [
                  IgnorePointer(
                    ignoring: data.isLoading,
                    child: Swiper(
                      scale: 0.2,
                      viewportFraction: viewRatio,
                      controller: widget.controller,
                      itemCount: data.countries.length,
                      physics: const BouncingScrollPhysics(),
                      onIndexChanged: (index) => _chooseCountryAt(index: index),
                      itemBuilder: (BuildContext context, int index) {
                        final CountryData country = data.countries[index];
                        return CountryItem(countryCode: country.code);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Builder(builder: (context) {
                      return IgnorePointer(
                        ignoring: widget.searchValue == null,
                        child: Stack(
                          children: [
                            CarouselRing(
                              size: viewHeight,
                              showLoader: data.isLoading,
                              blurred: (widget.searchValue ?? "").isNotEmpty,
                            ),
                            CarouselDisplay(
                              loading: data.isLoading,
                              onTap: () => _handleSearchDone(force: true),
                              value: _currentCountry?.name ?? "",
                              searchValue: widget.searchValue ?? "",
                              typeAhead: _suggestedCountry?.data.name ?? "",
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
