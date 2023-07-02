import 'package:aura/resources/app_styles.dart';
import 'package:flutter/material.dart';

class LightThemeStyles implements ThemeStyles {
  @override
  TextStyle get hugeText => const TextStyle(fontSize: 30);

  @override
  // TODO: implement paragraph
  TextStyle get paragraph => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
      );
}
