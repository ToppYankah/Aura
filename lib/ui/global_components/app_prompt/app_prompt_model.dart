import 'package:flutter/material.dart';

enum PromptPosition { top, center, bottom }

enum PromptType { warning, error, info, success }

class PromptMessage {
  final String title;
  final String message;
  final PromptType type;
  final String okayText;
  final String cancelText;
  final Future<void>? Function()? onOk;

  const PromptMessage({
    this.onOk,
    required this.title,
    required this.message,
    this.okayText = "Okay",
    this.cancelText = "Cancel",
    this.type = PromptType.warning,
  });
}

class PromptOptions {
  const PromptOptions({this.position = PromptPosition.bottom});

  final PromptPosition position;

  Alignment get getAlignment {
    switch (position) {
      case PromptPosition.top:
        return Alignment.topCenter;

      case PromptPosition.bottom:
        return Alignment.bottomCenter;

      default:
        return Alignment.center;
    }
  }
}
