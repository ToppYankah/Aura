import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // static const Color darkBackground = Color(0xFF150425);
  // #171528
  static const Color lightBackground = Color(0xFFEFF2FF);
  // static const Color lightBackground = Color(0xFFFFFFFF);

  static const Color goodRange = Color(0xFF1CB12B);
  static const Color moderateRange = Color(0xFFD7CF1E);
  static const Color unhealthyFCGRange = Color(0xFFF38621);
  static const Color unhealthyRange = Color(0xFFDE392E);
  static const Color veryUnhealthyRange = Color(0xFFC52CDE);
  static const Color hazardousRange = Color(0xFF8B115A);

  static const int _darkBackgroundValue = 0xFF171528;
  static const MaterialColor darkBackground = MaterialColor(0xFF171528, {
    50: Color(0xFFF4F4F5),
    100: Color(0xFFE8E8EA),
    200: Color(0xFFC5C5CA),
    300: Color(0xFFA0A0A7),
    400: Color(0xFF5D5C69),
    500: Color(_darkBackgroundValue),
    600: Color(0xFF151324),
    700: Color(0xFF0E0D18),
    800: Color(0xFF0B0A12),
    900: Color(0xFF07070C),
  });

  static const int _primaryValue = 0xFF5044BC;
  static const MaterialColor primary =
      MaterialColor(_primaryValue, <int, Color>{
    50: Color(0xFFEAE9F7),
    100: Color(0xFFCBC7EB),
    200: Color(0xFFA8A2DE),
    300: Color(0xFF857CD0),
    400: Color(0xFF6A60C6),
    500: Color(_primaryValue),
    600: Color(0xFF493EB6),
    700: Color(0xFF4035AD),
    800: Color(0xFF372DA5),
    900: Color(0xFF271F97),
  });

  static const int _secondaryValue = 0xFFFAC748;
  static const MaterialColor secondary =
      MaterialColor(_secondaryValue, <int, Color>{
    100: Color(0xFFFEFAF0),
    200: Color(0xFFFBF1D8),
    300: Color(0xFFF9E8BF),
    400: Color(0xFFF4D891),
    500: Color(_secondaryValue),
    600: Color(0xFFD5B157),
    700: Color(0xFF90773B),
    800: Color(0xFF6C5A2C),
    900: Color(0xFF463A1D),
  });
}
