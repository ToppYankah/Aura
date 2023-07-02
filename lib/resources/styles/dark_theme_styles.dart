import 'package:aura/resources/app_styles.dart';
import 'package:flutter/material.dart';

class DarkThemeStyles implements ThemeStyles {
  @override
  TextStyle get hugeText => const TextStyle(fontSize: 30);

  @override
  TextStyle get paragraph => const TextStyle(fontSize: 18);
}
