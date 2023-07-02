// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:aura/helpers/utils/app_logger.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/network/api/api_core.dart';
import 'package:aura/network/response.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_loader/app_loader_modal.dart';
import 'package:aura/ui/global_components/app_modal/app_modal.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

    log("Saving location as reference: $selectedLocation");

    if (selectedLocation != null) {
      final result = selectedLocation.parameters!.where(
        (element) => element.parameter == "pm25",
      );

      if (result.isNotEmpty) {
        log("Params: ${result.first.id} and ${selectedLocation.id}");
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
    if (status == PermissionStatus.granted) return await action();

    PromptMessage toastMessage = const PromptMessage(
      title: "Something went wrong",
      message:
          "Location permissions are permanently denied, we cannot request permissions.",
    );

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
    log("Starting $T background task");

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
}

class SpawnMessage<Args> {
  final SendPort port;
  final Args? otherArgs;

  const SpawnMessage({required this.port, this.otherArgs});
}
