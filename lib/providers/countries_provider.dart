import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:aura/network/api.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/cities/models/cities_request.dart';
import 'package:aura/network/api/cities/models/city_data.dart';
import 'package:aura/network/api/countries/models/countries_request.dart';
import 'package:aura/network/api/countries/models/country_data.dart';
import 'package:aura/network/response.dart';
import 'package:aura/providers/base_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/screens/choose_location_screen/data/location_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountriesProvider extends BaseProvider {
  CountriesProvider({
    required SharedPreferences preferences,
    required ApiCollection apiCollection,
  }) : super(preferences: preferences, apiCollection: apiCollection) {
    _preloadCacheData();
  }

  // ui variables
  CountryData? _selectedCountry;
  final List<CountryData> _countries = [];

  // Getters
  CountryData? get selectedCountry => _selectedCountry;
  UnmodifiableListView<CountryData> get countries =>
      UnmodifiableListView(_countries);
  List<String> get allCodes => _countries.map((e) => e.code!).toList();

  // Setters
  set countryValue(CountryData? value) {
    _selectedCountry = value;
    notifyListeners();
    _cacheSelectedCountry();
  }

  void _preloadCacheData() {
    // check for cache measurement reference data
    final String? countryCache =
        preferences.getString(PreferenceKeys.USER_COUNTRY);
    final List<String>? countriesCache =
        preferences.getStringList(PreferenceKeys.COUNTRIES);

    log("Preloading country cache data...");
    if (countryCache != null && countryCache.isNotEmpty) {
      // Preset measurement reference data
      _selectedCountry = CountryData.fromJson(jsonDecode(countryCache));
    }

    if (countriesCache != null && countriesCache.isNotEmpty) {
      _countries.addAll(
        countriesCache.map((e) => CountryData.fromJson(jsonDecode(e))).toList(),
      );
    }
  }

  void _cacheSelectedCountry() {
    log("Caching country data...");
    preferences.setString(
        PreferenceKeys.USER_COUNTRY, jsonEncode(_selectedCountry!.toJson()));
  }

  void _cacheCountries() {
    log("Caching countries data...");
    preferences.setStringList(PreferenceKeys.COUNTRIES,
        _countries.map((e) => e.toRawJson()).toList());
  }

  // Provider methods
  Future<void> getCountries() async {
    if (countries.isNotEmpty) return;

    startLoading();
    final CountriesRequest request = CountriesRequest(limit: 1000);

    final response = await apiCollection.countriesApi
        .getCountries(countriesRequest: request);

    if (response.status == ResponseStatus.successful) {
      // Clear existing countries
      _countries.clear();
      // Save countries data
      _countries.addAll(response.response!.data!.results!);
      // set default selected to first country
      _selectedCountry = _countries.first;
    } else {
      // Save error message
      setError = response.error?.detail?[0].msg;
    }

    stopLoading();

    // cache countries
    if (_countries.isNotEmpty) _cacheCountries();
  }

  SearchResult<CountryData>? findCountry(String filter) {
    CountryData result = countries.firstWhere(
      (element) =>
          element.name!.toLowerCase().startsWith(filter.trim().toLowerCase()),
      orElse: () => CountryData(name: "", code: ""),
    );

    if (result.name!.isEmpty) return null;

    final int index = countries.indexOf(result);
    return SearchResult(data: result, index: index);
  }

  Future getCountryFromLocation(String? code) async {
    try {
      final CountriesRequest request = CountriesRequest(country: code);

      final response = await apiCollection.countriesApi
          .getCountries(countriesRequest: request);

      if (response.status == ResponseStatus.successful) {
        final result = response.response!.data!.results;

        if (result != null && result.isNotEmpty) {
          // set default selected to first country
          _selectedCountry = result.first;
        }
      } else {
        // Save error message
        setError = response.error?.detail?[0].msg;
      }
    } catch (e) {}
  }

  Future<FutureResponse<List<CityData>>> getCities(CountryData? country) async {
    if (country == null) {
      return FutureResponse(error: "Country is required for search");
    }

    if (country.code!.isEmpty) {
      return FutureResponse(error: "Country name cannot be empty");
    }

    final CitiesRequest request = CitiesRequest(country: country.code);

    final response =
        await apiCollection.citiesApi.getCities(citiesRequest: request);

    if (response.status == ResponseStatus.successful) {
      // Return cities data
      return FutureResponse(data: response.response!.data!.results);
    }
    // Return error message
    return FutureResponse(error: response.error?.detail?[0].msg);
  }
}
