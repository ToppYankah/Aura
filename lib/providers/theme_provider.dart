import 'package:aura/helpers/theme/theme_dark.dart';
import 'package:aura/helpers/theme/theme_interface.dart';
import 'package:aura/helpers/theme/theme_light.dart';
import 'package:aura/providers/base_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ApplicationTheme {
  ThemeData? theme;
}

enum ThemeEnum { dark, light }

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => watch<ThemeProvider>().currentTheme;
}

class ThemeProvider extends BaseProvider implements IThemeProvider {
  ThemeProvider(
      {required SharedPreferences preferences, required apiCollection})
      : super(apiCollection: apiCollection, preferences: preferences) {
    final bool? isDarkTheme = preferences.getBool(PreferenceKeys.IS_DARK_THEME);

    switch (isDarkTheme) {
      case false:
        currentThemeEnum = ThemeEnum.light;
        currentTheme = ThemeEnum.light.generateTheme;
        break;
      default:
        currentThemeEnum = ThemeEnum.dark;
        currentTheme = ThemeEnum.dark.generateTheme;
        break;
    }
  }

  @override
  ThemeEnum currentThemeEnum = ThemeEnum.dark;

  @override
  ThemeData currentTheme = ThemeEnum.dark.generateTheme;

  @override
  void toggleTheme() {
    switch (currentThemeEnum) {
      case ThemeEnum.light:
        currentThemeEnum = ThemeEnum.dark;
        currentTheme = ThemeEnum.dark.generateTheme;
        break;

      default:
        currentThemeEnum = ThemeEnum.light;
        currentTheme = ThemeEnum.light.generateTheme;
    }
    notifyListeners();
    _saveToPreferences();
  }

  void _saveToPreferences() {
    preferences.setBool(
      PreferenceKeys.IS_DARK_THEME,
      currentThemeEnum == ThemeEnum.dark,
    );
  }
}

extension ThemeEnumExtension on ThemeEnum {
  ThemeData get generateTheme {
    switch (this) {
      case ThemeEnum.light:
        return ThemeLight.instance.theme!;
      case ThemeEnum.dark:
        return ThemeDark.instance.theme!;
      default:
        return ThemeLight.instance.theme!;
    }
  }
}
