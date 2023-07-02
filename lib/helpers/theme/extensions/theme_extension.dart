import 'package:aura/resources/app_styles.dart';
import 'package:flutter/material.dart';

@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  final Color? border;
  final Color? heading;
  final Color? paragraph;
  final Color? background;
  final ThemeStyles? styles;
  final Color? paragraphDeep;
  final Color? cardBackground;
  final Color? placeholderText;

  const AppTheme({
    this.styles,
    required this.border,
    required this.placeholderText,
    required this.heading,
    required this.paragraph,
    required this.background,
    required this.paragraphDeep,
    required this.cardBackground,
  });

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? border,
    Color? button,
    Color? heading,
    Color? paragraph,
    Color? background,
    Color? paragraphDeep,
    Color? cardBackground,
  }) {
    return AppTheme(
      placeholderText: button ?? this.placeholderText,
      border: border ?? this.border,
      heading: heading ?? this.heading,
      paragraph: paragraph ?? this.paragraph,
      background: background ?? this.background,
      paragraphDeep: paragraphDeep ?? this.paragraphDeep,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return AppTheme(
      placeholderText: Color.lerp(placeholderText, other.placeholderText, t),
      border: Color.lerp(border, other.border, t),
      heading: Color.lerp(heading, other.heading, t),
      paragraph: Color.lerp(paragraph, other.paragraph, t),
      background: Color.lerp(background, other.background, t),
      paragraphDeep: Color.lerp(paragraph, other.paragraphDeep, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
    );
  }

  @override
  String toString() {
    return 'AppThemeColors(border: $border, button: $placeholderText, heading: $heading,paragraph: $paragraph, paragraphDark: $paragraphDeep, background: $background,cardBackground: $cardBackground,)';
  }
}
