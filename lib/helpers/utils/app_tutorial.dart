// ignore_for_file: use_build_context_synchronously

import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialItem {
  final Widget widget;
  final String identifier;
  final GlobalKey<State<StatefulWidget>> key;

  TutorialItem(
      {required this.key, required this.widget, required this.identifier});
}

class AppTutorial {
  final List<TargetFocus> _targets = [];

  AppTutorial();

  void initialize(List<TutorialItem> targets) {
    for (var target in targets) {
      _targets.add(
        TargetFocus(
          keyTarget: target.key,
          identify: target.identifier,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: target.widget,
            )
          ],
        ),
      );
    }
  }

  void showTutorial(BuildContext context,
      {required String viewChekcker, bool allowSkip = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isFirstTime = prefs.getBool(viewChekcker);

    if (isFirstTime != null) return;
    prefs.setBool(viewChekcker, false);

    TutorialCoachMark(
      targets: _targets,
      opacityShadow: 0.9,
      hideSkip: !allowSkip,
      skipWidget: const AppTextButton(
        text: "SKIP",
        paddingSpace: 30,
        enableBackground: true,
        icon: IconlyBold.arrow_right_3,
        iconPosition: IconPosition.after,
      ),
    ).show(context: context);
  }
}
