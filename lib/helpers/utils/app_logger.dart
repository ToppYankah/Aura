import 'dart:developer';

import 'package:flutter/foundation.dart';

enum LogType { info, warning, error, success }

const Map<LogType, Map<String, String>> logColors = {
  LogType.success: {"\x1B[32m": "\x1B[0m"},
  LogType.warning: {"\x1B[33m": "\x1B[0m"},
  LogType.error: {"\x1B[31m": "\x1B[0m"},
  LogType.info: {"\x1B[34m": "\x1B[0m"},
};

class AppLogger {
  static void logOne(LogItem logItem, {LogType type = LogType.warning}) {
    if (!kDebugMode) return;

    MapEntry colorData = logColors[type]!.entries.first;
    String output =
        "${colorData.key}◉◉◉◉◉◉◉◉◉◉ 📌 ${logItem.title} 📌  ◉◉◉◉◉◉◉◉◉◉◉◉◉◉\n";

    if (logItem.data != null) {
      for (String key in logItem.data!.keys) {
        output += "\n ✔︎ $key ::: ${logItem.data![key]}";
      }
    } else {
      output += "\n No Data to log 🫙";
    }

    output +=
        "\n◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉${colorData.value}";
    log(output);
  }

  static void logGroup(List<LogItem> data, String? title,
      {LogType type = LogType.warning}) {
    if (!kDebugMode) return;

    MapEntry colorData = logColors[type]!.entries.first;
    String output =
        "${colorData.key}◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉ 📌 $title 📌 ◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉";
    for (var logItem in data) {
      output += "\n❍❍ ${logItem.title} ❍❍❍❍❍❍❍❍❍❍❍";

      if (logItem.data != null) {
        for (String key in logItem.data!.keys) {
          output += "\n ✔︎ $key ::: ${logItem.data![key]}";
        }
      } else {
        output += "\n No Data to log 🫙";
      }

      output += "\n";
    }
    output +=
        "\n◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉◉${colorData.value}";
    log(output);
  }
}

class LogItem {
  final String title;
  final Map<String, dynamic>? data;

  LogItem({required this.title, this.data});
}
