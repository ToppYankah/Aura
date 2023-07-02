import 'package:aura/helpers/theme/extensions/theme_extension.dart';
import 'package:aura/resources/styles/light_theme_styles.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeLight extends ApplicationTheme {
  static ThemeLight? _instance;
  static ThemeLight get instance {
    _instance ??= ThemeLight._init();
    return _instance!;
  }

  ThemeLight._init();

  @override
  ThemeData? get theme => ThemeData(
        // colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
        fontFamily: AppFonts.lufgaFont,
        fontFamilyFallback: const [AppFonts.gilroyFont],
        extensions: {
          AppTheme(
            styles: LightThemeStyles(),
            border: Colors.white70,
            cardBackground: Colors.white,
            heading: AppColors.darkBackground,
            paragraphDeep: Colors.grey.shade700,
            placeholderText: Colors.grey.shade400,
            background: AppColors.lightBackground,
            paragraph: AppColors.darkBackground.withOpacity(0.5),
          ),
        },
      );
}

// Original Theme
// AppTheme(
//             button: Colors.black,
//             styles: LightThemeStyles(),
//             border: Colors.grey.shade300,
//             heading: AppColors.darkBackground,
//             paragraphDeep: Colors.grey.shade700,
//             cardBackground: Colors.grey.shade100,
//             background: AppColors.lightBackground,
//             paragraph: AppColors.darkBackground.withOpacity(0.5),
//           ),