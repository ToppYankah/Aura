import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/helpers/utils/pollutant_util.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/api/measurements/models/latest_measurement_data.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/screens/readings_screen/models/graph_data.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:aura/providers/base_provider.dart';
import 'package:aura/network/api/measurements/models/measurement_data.dart';
import 'package:aura/network/api/measurements/models/measurements_request.dart';

class TimeRange {
  final DateTime start;
  final DateTime end;

  const TimeRange({required this.start, required this.end});
}

class MeasurementReference implements Serializable {
  final int locationId;
  final int parameterId;

  const MeasurementReference(
      {required this.locationId, required this.parameterId});

  @override
  Map<String, dynamic> toJson() {
    return {"locationId": locationId, "parameterId": parameterId};
  }

  factory MeasurementReference.fromJson(Map json) {
    return MeasurementReference(
      locationId: json["locationId"],
      parameterId: json["parameterId"],
    );
  }
}

class MeasurementsProvider extends BaseProvider {
  // Provider properties -----------------------------------------------------------------------------------------------
  AQIDetails? _aqiDetails;
  bool _useAQIValue = true;
  LatestMeasurementData? _latest;
  MeasurementReference? _reference;
  Moment _selectedDate = Moment.now();
  final List<MeasurementData> _dailyMeasurements = [];
  final List<MeasurementData> _weeklyMeasurements = [];

  // Constructor -----------------------------------------------------------------------------------------------
  MeasurementsProvider({required apiCollection, required preferences})
      : super(apiCollection: apiCollection, preferences: preferences) {
    _loadCachedReference();

    if (_reference != null) {
      getLatestMeasurement();
      getRecordedMeasurements();
    }
  }

  // Getters ------------------------------------------------------------------------------------------------------------
  bool get useAQIValue => _useAQIValue;
  Moment get selectedDate => _selectedDate;
  AQIDetails? get aqiDetails => _aqiDetails;
  bool get hasReference => _reference != null;
  LatestMeasurementData? get latest => _latest;
  UnmodifiableListView<MeasurementData> get dailyMeasurements =>
      UnmodifiableListView(_dailyMeasurements);
  UnmodifiableListView<MeasurementData> get weeklyMeasurements =>
      UnmodifiableListView(_weeklyMeasurements);

  String get lastUpdated {
    final result = (_latest?.measurements ?? [])
        .where((element) => element.parameter == "pm25");

    if (result.isNotEmpty) {
      return Moment(result.first.lastUpdated!).fromNow();
    }

    return "Some time ago";
  }

  double get maxReading {
    double output = 10;
    if (_dailyMeasurements.isNotEmpty) {
      final newMeasurements = [..._dailyMeasurements];
      newMeasurements.sort((a, b) => a.value!.compareTo(b.value!));
      output = newMeasurements.last.value!;
    }

    return output + 2;
  }

  double get patternsMaxReading {
    double output = 10;
    if (getPattern.isNotEmpty) {
      final newMeasurements = [...getPattern];
      newMeasurements.sort((a, b) => a.yMax.compareTo(b.yMax));
      output = newMeasurements.last.yMax;
    }
    print("Max Weekly Pattern Output: $output");
    return output + 2;
  }

  String get displayValue {
    if (_useAQIValue) return aqiDisplayValue;

    String? pm25Value;
    final result = (_latest?.measurements ?? [])
        .where((element) => element.parameter == "pm25");

    if (result.isNotEmpty) {
      final range = PollutantUtils.findConcentrationCategory(
        key: "pm25",
        concentration: result.first.value!,
      );

      if (result.first.value! > range.max) {
        pm25Value = "500+";
      } else {
        pm25Value = result.first.value!.toStringAsFixed(1);
      }
    }

    return pm25Value ?? "-.-";
  }

  String get aqiDisplayValue {
    String? aqiValue = _aqiDetails?.value.toString();
    if (_useAQIValue) {
      if (_aqiDetails != null && _aqiDetails!.value > 500) {
        aqiValue = "500+";
      }
    }
    return aqiValue ?? "-.-";
  }

  UnmodifiableListView<GraphData> get readings => UnmodifiableListView(
        _dailyMeasurements.map((element) => GraphData(
              unit: element.unit!,
              x: element.date!.utc!,
              y: element.value!,
            )),
      );

  UnmodifiableListView<MinMaxGraphData> get getPattern {
    Moment currentHour = _selectedDate.startOfDay();
    final List<MinMaxGraphData> output = [];

    for (var i = 0; i < 24; i++) {
      final List<MeasurementData> matching =
          _weeklyMeasurements.where((element) {
        Moment moment = Moment(element.date!.utc!);
        return currentHour.isAtSameHourAs(moment);
      }).toList();

      if (matching.isEmpty) {
        currentHour = currentHour.add(const Duration(hours: 1));
        continue;
      }

      matching.sort((a, b) => a.value!.compareTo(b.value!));

      output.add(
        MinMaxGraphData(
          x: currentHour,
          y: matching.first.value!,
          yMax: matching.last.value!,
        ),
      );

      currentHour = currentHour.add(const Duration(hours: 1));
    }

    print("Pattern Output Length: ${output.length}");

    return UnmodifiableListView(output);
  }

  UnmodifiableListView<GraphData> get aqiReadings => UnmodifiableListView(
        _dailyMeasurements.map(
          (element) {
            final PollutantBreakpoint breakpoint =
                PollutantUtils.findConcentrationCategory(
                    key: "pm25", concentration: element.value!);

            final AQIDetails aqiDetails = AQIUtil.getAQIDetails(
              breakpoint: breakpoint,
              concentration: element.value!,
            );

            return GraphData(
              unit: "AQI",
              x: Moment(element.date!.utc!),
              y: aqiDetails.value.toDouble(),
            );
          },
        ),
      );

  void _loadCachedReference() {
    // check for cache measurement reference data
    final String? referenceCache =
        preferences.getString(PreferenceKeys.MEASUREMENT_REFERENCE);

    log("Preloading measurements cache data...");
    if (referenceCache != null && referenceCache.isNotEmpty) {
      final json = jsonDecode(referenceCache);
      log("Cache Json: $json");
      // Preset measurement reference data
      _reference = MeasurementReference.fromJson(json);
    }
  }

  void _cacheMeasurementReference() {
    log("Caching measurement reference data...");
    preferences.setString(
        PreferenceKeys.MEASUREMENT_REFERENCE, jsonEncode(_reference!.toJson()));
  }

  Moment readingsVisibleMaximum({Duration hours = const Duration(hours: 12)}) =>
      _selectedDate.startOfDay().add(hours);

  // Setters ------------------------------------------------------------------------------------------------------------
  set setDate(Moment date) {
    _selectedDate = date;
    update();
    // fetch measurements against new date
    getRecordedMeasurements();
  }

  set setReference(MeasurementReference ref) {
    log("Location Reference Data: $ref");
    _reference = ref;
    getLatestMeasurement();
    _cacheMeasurementReference();
  }

  set setUseAQIValue(bool value) {
    _useAQIValue = value;
    update();
  }

  void _setAQIDetails() {
    final List<SimpleMeasurementData>? result = _latest?.measurements
        ?.where((element) => element.parameter == "pm25")
        .toList();

    if (result != null && result.isNotEmpty) {
      final double concentration = result.first.value!;

      _aqiDetails = AQIUtil.getAQIDetails(
        concentration: concentration,
        breakpoint: PollutantUtils.pollutantBreakpoints["pm25"]!
            .getCategory(concentration),
      );
    }
  }

  Future getLatestMeasurementAsync() async {
    print("Reference: $_reference");
    if (_reference == null) {
      stopLoading();
      return;
    }

    final MeasurementsRequest request = MeasurementsRequest(
      locationId: _reference!.locationId,
    );

    final response = await apiCollection.measurementsApi
        .getLatestMeasurementsByLocationId(latestMeasurementsRequest: request);

    if (response.status == ResponseStatus.successful) {
      final data = response.response!.data!.results!;
      log("Latest Measurement Result: ${data.length} SMH");

      if (data.isNotEmpty) {
        _latest = data.last;
        _setAQIDetails();
      }
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
    }
  }

  void getLatestMeasurement() async {
    startLoading();
    await getLatestMeasurementAsync();
    stopLoading();
  }

  // Provider Methods ------------------------------------------------------------------------------------------------------------
  void getRecordedMeasurements() async {
    startLoading();

    print("Reference: $_reference");
    if (_reference == null) {
      stopLoading();
      return;
    }

    final MeasurementsRequest request = MeasurementsRequest(
      limit: 300,
      dateTo: _selectedDate.endOfDay(),
      parameter: _reference!.parameterId,
      locationId: _reference!.locationId,
      dateFrom: _selectedDate.startOfDay(),
    );

    final response = await apiCollection.measurementsApi
        .getMeasurements(measurementsRequest: request);

    if (response.status == ResponseStatus.successful) {
      final data = response.response!.data!.results!;
      log("Measurements Result: ${data.length}");

      // Clear existing locations
      _dailyMeasurements.clear();
      // Save locations data
      _dailyMeasurements.addAll(data);
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
    }

    stopLoading();
  }

  Future<void> getWeeklyMeasurements() async {
    print("Reference: $_reference");
    if (_reference == null) {
      stopLoading();
      return;
    }

    final MeasurementsRequest request = MeasurementsRequest(
      limit: 24 * 7,
      dateTo: _selectedDate,
      parameter: _reference!.parameterId,
      locationId: _reference!.locationId,
      dateFrom: _selectedDate.subtract(const Duration(days: 14)),
    );

    final response = await apiCollection.measurementsApi
        .getMeasurements(measurementsRequest: request);

    if (response.status == ResponseStatus.successful) {
      final data = response.response!.data!.results!;
      for (var item in data) {
        log(item.toRawJson() + "\n");
      }

      // Clear existing locations
      _weeklyMeasurements.clear();
      // Save locations data
      _weeklyMeasurements.addAll(data);
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
    }
  }

  Future<List<LatestMeasurementData>> getMapMeasurements() async {
    final MeasurementsRequest request =
        MeasurementsRequest(limit: 5000, parameter: 2);

    final response = await apiCollection.measurementsApi
        .getLatestMeasurements(latestMeasurementsRequest: request);

    log("Response Status: ${response.status}");

    if (response.status == ResponseStatus.successful) {
      final result = response.response!.data!.results!;
      return result;
    } else {
      // Show error message
      setError = response.error?.detail?[0].msg;
      AppLogger.logOne(
        LogItem(title: "Request Failure", data: response.toJson()),
        type: LogType.error,
      );
    }
    return [];
  }
}
