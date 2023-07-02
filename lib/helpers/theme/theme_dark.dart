import 'package:aura/helpers/theme/extensions/theme_extension.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/resources/styles/dark_theme_styles.dart';
import 'package:flutter/material.dart';

class ThemeDark extends ApplicationTheme {
  static ThemeDark? _instance;
  static ThemeDark get instance {
    _instance ??= ThemeDark._init();
    return _instance!;
  }

  ThemeDark._init();

  @override
  ThemeData? get theme => ThemeData(
        // colorScheme: const ColorScheme.dark(),
        brightness: Brightness.dark,
        fontFamily: AppFonts.lufgaFont,
        fontFamilyFallback: const [AppFonts.gilroyFont],
        extensions: <ThemeExtension<dynamic>>[
          AppTheme(
            heading: Colors.white,
            border: Colors.white10,
            styles: DarkThemeStyles(),
            paragraph: Colors.white54,
            paragraphDeep: Colors.white70,
            placeholderText: Colors.white38,
            cardBackground: Colors.white.withOpacity(0.05),
            background: AppColors.darkBackground.shade700,
            // background: AppColors.darkBackground,
          ),
        ],
      );
}
