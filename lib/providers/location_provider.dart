// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:collection';
import 'dart:developer';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/providers/base_provider.dart';
import 'package:aura/network/api/locations/models/location_data.dart';
import 'package:aura/network/api/locations/models/locations_request.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends BaseProvider {
  LocationProvider({required preferences, required apiCollection})
      : super(apiCollection: apiCollection, preferences: preferences) {
    _preloadCacheData();
  }

  // Private properties
  Position? _userPosition;
  LocationData? _selectedLocation;
  bool _usingCurrentLocation = false;
  final List<LocationData> _locations = [];

  // Getters --------------------------------------------------------------
  Position? get userPosition => _userPosition;
  bool get hasLocation => _selectedLocation != null;
  bool get usingCurrentLocation => _usingCurrentLocation;
  LocationData? get selectedLocation => _selectedLocation;
  UnmodifiableListView<LocationData> get locations =>
      UnmodifiableListView(_locations);

  // Setters --------------------------------------------------------------
  set locationValue(LocationData location) {
    _usingCurrentLocation = false;
    _selectedLocation = location;
    update();

    // cache user location on change
    _cacheLocationData();
  }

  // Methods --------------------------------------------------------------
  void _cacheLocationData() {
    log("Caching location data...");
    preferences.setString(
        PreferenceKeys.USER_LOCATION, _selectedLocation!.toRawJson());
  }

  void _preloadCacheData() {
    // check for cache user location data
    final String? locationCache =
        preferences.getString(PreferenceKeys.USER_LOCATION);

    log("Preloading location cache data...");
    if (locationCache != null && locationCache.isNotEmpty) {
      // Preset selected location with cache data
      _selectedLocation = LocationData.fromJson(jsonDecode(locationCache));

      // updateLocationData();
    }
  }

  Future<String?> getLocationCityName() async {
    if (_selectedLocation?.city != null) {
      return _selectedLocation?.city;
    }

    final placemarks = await placemarkFromCoordinates(
      _selectedLocation!.coordinates!.latitude!,
      _selectedLocation!.coordinates!.longitude!,
    );

    if (placemarks.isNotEmpty) {
      return "${placemarks.first.street}, ${placemarks.first.country}";
    }

    return null;
  }

  void updateLocationData() async {
    startLoading();
    final LocationData? update =
        await _getLocationById(_selectedLocation?.id ?? -1);

    if (update != null) locationValue = update;
    stopLoading();
  }

  void deselectLocation() {
    _selectedLocation = null;
    update();
  }

  GlobalKey get getLocationKey {
    if (_locations.isNotEmpty) {
      final result =
          _locations.where((element) => element.id == _selectedLocation!.id);
      if (result.isNotEmpty) return result.first.key!;
    }

    return GlobalKey();
  }

  Future getUserCurrentLocation() async {
    startLoading();
    try {
      // Get user's position from geolocator
      _userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Send coordinates to API for location details
      final LocationData? result = await _getLocationFromCoords(_userPosition!);

      // Save location details
      if (result != null) {
        locationValue = result;
        _usingCurrentLocation = true;
      } else {
        setError = "Could not find any places around you.";
      }
    } catch (e) {
      // save error
      setError = e.toString();

      // Log error
      AppLogger.logGroup([
        LogItem(title: "Message", data: {
          "Error Object": e,
        })
      ], "Get Location Failure");
    }
    stopLoading();
  }

  Future<LocationData?> _getLocationById(int id) async {
    final LocationsRequest request = LocationsRequest();

    final response = await apiCollection.locationsApi
        .getLocationById(id, locationsRequest: request);

    if (response.status == ResponseStatus.successful) {
      // Save locations data
      return response.response?.data?.results?.first;
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
      return null;
    }
  }

  Future<LocationData?> _getLocationFromCoords(Position position) async {
    final LocationsRequest request = LocationsRequest(
        coordinates: "${position.latitude},${position.longitude}", limit: 1);

    final response = await apiCollection.locationsApi
        .getLocations(locationsRequest: request);

    if (response.status == ResponseStatus.successful) {
      final results = response.response!.data!.results!;
      if (results.isNotEmpty) return results.last;
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
    }

    return null;
  }

  void getCountryLocations({String? countryCode}) async {
    startLoading();

    final LocationsRequest request =
        LocationsRequest(country: countryCode, limit: 30);

    final response = await apiCollection.locationsApi
        .getLocations(locationsRequest: request);

    log("Response Status: ${response.status}");

    if (response.status == ResponseStatus.successful) {
      // Clear existing locations
      _locations.clear();
      // Save locations data
      _locations.addAll(response.response!.data!.results!);
      update();
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
      AppLogger.logOne(
        LogItem(title: "Request Failure", data: response.toJson()),
        type: LogType.error,
      );
    }

    stopLoading();
  }
}
