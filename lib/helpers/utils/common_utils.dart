// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aura/network/response.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/ui/global_components/app_modal/app_modal.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_loader/app_loader_modal.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';

class CommonUtils {
  CommonUtils._();

  static int defaultRefreshInterval = 5;

  static RegExp urlRegex =
      RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

  static Future<void> saveLocationAsReferenceForMeasurement(
      BuildContext context) async {
    final measurementProvider =
        Provider.of<MeasurementsProvider>(context, listen: false);
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    final selectedLocation = locationProvider.selectedLocation;

    AppLogger.logOne(
      LogItem(
        title: "Saving location as reference",
        data: {"data": selectedLocation},
      ),
    );

    if (selectedLocation != null) {
      final result = selectedLocation.parameters!.where(
        (element) => element.parameter == "pm25",
      );

      if (result.isNotEmpty) {
        AppLogger.logOne(
          LogItem(
            title: "Params",
            data: result.first.toJson()..addAll(selectedLocation.toJson()),
          ),
        );
        measurementProvider.setReference = MeasurementReference(
          parameterId: result.first.id!,
          locationId: selectedLocation.id!,
        );
      }
    }
  }

  static Future<void> requiresGPSPermission(
    BuildContext context,
    Future? Function() action,
  ) async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) return await action();

    String title = switch (status) {
      PermissionStatus.denied => 'Access Denied',
      PermissionStatus.restricted => 'Access Restricted',
      PermissionStatus.permanentlyDenied => 'Access Permanently Denied',
      _ => 'Access Not Granted'
    };

    String message = switch (status) {
      PermissionStatus.restricted =>
        'This app is not allowed to use your current location.',
      PermissionStatus.denied =>
        'You have disabled the permission for this application or you\'ve previously rejected it',
      PermissionStatus.permanentlyDenied =>
        'The user has blocked access to their device location and/or they have declined to give access',
      _ => 'Location access was denied'
    };

    PromptMessage toastMessage = PromptMessage(title: title, message: message);

    PromptUtil.show(context, toastMessage);
  }

  static void showModal(
    BuildContext context, {
    required Widget Function(VoidCallback) child,
    ModalOptions options = const ModalOptions(),
  }) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) {
        return AppModal(options: options, onClose: entry!.remove, child: child);
      },
    );

    overlayState.insert(entry);
  }

  static Future<T?> callLoader<T>(BuildContext context, Function action,
      {String? message, VoidCallback? onError}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? entry;
    T? output;

    entry = OverlayEntry(
      builder: (context) {
        return AppLoaderModal(message: message);
      },
    );

    overlayState.insert(entry);

    try {
      output = await action();
    } catch (e) {
      (onError ?? () {})();
      AppLogger.logOne(
        LogItem(title: "Unexpected Error", data: {"data": e}),
        type: LogType.error,
      );
    }

    entry.remove();
    return output;
  }

  static Future<List<File>?> pickImages({int? max}) async {
    /// Get from gallery
    try {
      List<XFile> files = await ImagePicker().pickMultiImage();

      if (max != null && files.length >= max) {
        return files.sublist(0, max).map((file) => File(file.path)).toList();
      }

      if (files.isNotEmpty) {
        return files.map((file) => File(file.path)).toList();
      }

      return [];
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Image Picker Failed", data: {"Message": e}),
        type: LogType.error,
      );
    }

    return null;
  }

  static Future<List<ApiResponse>> promiseAll<T>(
      List<Future<ApiResponse>> futures) async {
    return Future.wait(futures);
  }

  static Future<String?> getLocationCity(Coordinates coords,
      {bool withCountry = false}) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        coords.latitude!,
        coords.longitude!,
      );

      if (placemarks.isNotEmpty) {
        final found = placemarks.first;
        return "${found.locality ?? "Unknown City"}${withCountry ? ", ${found.country}" : ""}";
      }
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Get Location City Error", data: {"Message": e}),
        type: LogType.error,
      );
    }

    return null;
  }

  static void initializeAutoReloadLatestMeasurements(
      BuildContext context) async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final measurementsProvider =
        Provider.of<MeasurementsProvider>(context, listen: false);

    Duration duration =
        Duration(minutes: settingsProvider.prefs.refreshInterval);

    Timer.periodic(duration, (timer) async {
      AppLogger.logOne(
        LogItem(
          title: "Check Periodic Load",
          data: {"Time in Minute:": settingsProvider.prefs.refreshInterval},
        ),
      );
      await measurementsProvider.getLatestMeasurementAsync();
      duration = Duration(minutes: settingsProvider.prefs.refreshInterval);
    });
  }

  static void performPostBuild(BuildContext context, Function action) =>
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (context.mounted) action();
      });

  static Future<List<Object?>> doPrefetchs(
      {required BuildContext context}) async {
    return Future.wait([]);
  }

  static Future<OutputType?> runIsolateTask<InputType, OutputType>(
      OutputType Function(InputType? data) action,
      {dynamic args}) async {
    final ReceivePort receivePort = ReceivePort();

    try {
      await Isolate.spawn(
        (message) => message.port.send(action(message.otherArgs)),
        SpawnMessage<InputType>(port: receivePort.sendPort, otherArgs: args),
      );

      return await receivePort.first;
    } catch (e) {
      AppLogger.logOne(
        LogItem(title: "Isolate Error!!!", data: {"Message": e}),
        type: LogType.error,
      );
      return null;
    }
  }

  static Future<T> getResponseInBackground<T>(
      jsonData, T Function(Map<String, dynamic>? data) method,
      {required T Function() orElse}) async {
    AppLogger.logOne(
      LogItem(
        title: "Starting background task",
        data: {"type": T},
      ),
    );

    T? output = await runIsolateTask<Map<String, dynamic>, T>(
      (isolateData) => method(isolateData),
      args: jsonData,
    );

    if (output == null) return orElse();
    return output;
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static Future<void> sendEmail(BuildContext context,
      {String? subject, String? body}) async {
    Map<String, String> query = {};

    if (body != null) query["body"] = body;
    if (subject != null) query["subject"] = subject;

    final Uri emailLaunchUri = Uri(
      path: AppStrings.mail,
      scheme: AppStrings.mailScheme,
      query: query.keys.isNotEmpty ? _encodeQueryParameters(query) : null,
    );

    await launchUrl(emailLaunchUri);
  }

  static Future<void> callUs(BuildContext context) async {
    final Uri phoneCallUri =
        Uri(path: AppStrings.phone, scheme: AppStrings.phoneScheme);

    await launchUrl(phoneCallUri);
  }

  static double haversineDistance(Coordinates coord1, Coordinates coord2,
      {Unit unit = Unit.km}) {
    AppLogger.logOne(
      LogItem(
          title: "Coordinates",
          data: {"Coord1": coord1.toJson(), "Coord2": coord2.toJson()}),
    );

    const double earthRadius = 6371; // Radius of the Earth in kilometers

    double dLat = _toRadians(coord2.latitude! - coord1.latitude!);
    double dLon = _toRadians(coord2.longitude! - coord1.longitude!);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(coord1.latitude!)) *
            cos(_toRadians(coord2.latitude!)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // distance in kilometers
    double distance = earthRadius * c;

    return switch (unit) {
      Unit.cm => distance * 100000,
      Unit.m => distance * 1000,
      Unit.km => distance,
    };
  }
}

enum Unit { km, cm, m }

double _toRadians(double degrees) {
  return degrees * pi / 180;
}

class SpawnMessage<Args> {
  final SendPort port;
  final Args? otherArgs;

  const SpawnMessage({required this.port, this.otherArgs});
}
