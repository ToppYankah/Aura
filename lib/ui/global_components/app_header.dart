// ignore_for_file: use_build_context_synchronously

import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final Widget? trailing;
  final Function? onBack;
  const AppHeader({
    super.key,
    this.title,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppIconButton(
                    icon: IconlyBold.arrow_left_3,
                    onTap: () async {
                      await (onBack ?? () {})();
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    title ?? "",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: theme.heading,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      );
    });
  }
}
