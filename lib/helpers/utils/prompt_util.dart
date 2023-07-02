import 'package:aura/ui/global_components/app_prompt/app_prompt.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:flutter/material.dart';

class PromptUtil {
  static void show(BuildContext context, PromptMessage prompt,
      {PromptOptions? options}) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) {
        return AppPromptNotifier(
          message: prompt,
          onClose: () => entry?.remove(),
          options: options ?? const PromptOptions(),
        );
      },
    );

    overlayState.insert(entry);
  }
}
