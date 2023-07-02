import 'package:flutter/material.dart';

import '../../providers/theme_provider.dart';

abstract class IThemeProvider {
  late ThemeData currentTheme;
  late ThemeEnum currentThemeEnum;

  void toggleTheme();
  // void changeTheme(ThemeEnum theme);
}
