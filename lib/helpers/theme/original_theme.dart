// import 'package:aura/providers/theme_provider.dart';
// import 'package:aura/resources/app_colors.dart';
// import 'package:aura/resources/app_strings.dart';
// import 'package:flutter/material.dart';

///////////////////////////////////////////////////  LIGHT  ////////////////////////////////////////////////////
///
// class ThemeLight extends ApplicationTheme {
//   static ThemeLight? _instance;
//   static ThemeLight get instance {
//     _instance ??= ThemeLight._init();
//     return _instance!;
//   }

//   ThemeLight._init();

//   @override
//   ThemeData? get theme => ThemeData(
//         extensions: <ThemeExtension<dynamic>>[
//           // your colors and styles
//         ],
//         primarySwatch: const MaterialColor(4288120051, {
//           50: Color(0xffebe8fd),
//           100: Color(0xffd8d1fa),
//           200: Color(0xffb0a2f6),
//           300: Color(0xff8974f1),
//           400: Color(0xff6245ed),
//           500: Color(0xff3b17e8),
//           600: Color(0xff2f12ba),
//           700: Color(0xff230e8b),
//           800: Color(0xff17095d),
//           900: Color(0xff0c052e)
//         }),
//         colorScheme: const ColorScheme.light(
//           background: AppColors.lightBackground,
//         ),
//         brightness: Brightness.light,
//         fontFamily: AppFonts.lufgaFont,
//         fontFamilyFallback: const [AppFonts.gilroyFont],
//         primaryColor: const Color(0xff9784f3),
//         primaryColorLight: const Color(0xffd8d1fa),
//         primaryColorDark: const Color(0xff230e8b),
//         canvasColor: const Color(0xfffafafa),
//         scaffoldBackgroundColor: const Color(0xfffafafa),
//         bottomAppBarColor: const Color(0xffffffff),
//         cardColor: const Color(0xffffffff),
//         dividerColor: const Color(0x1f000000),
//         highlightColor: const Color(0x66bcbcbc),
//         splashColor: const Color(0x66c8c8c8),
//         selectedRowColor: const Color(0xfff5f5f5),
//         unselectedWidgetColor: const Color(0x8a000000),
//         disabledColor: const Color(0x61000000),
//         toggleableActiveColor: const Color(0xff2f12ba),
//         secondaryHeaderColor: const Color(0xffebe8fd),
//         backgroundColor: const Color(0xffb0a2f6),
//         dialogBackgroundColor: const Color(0xffffffff),
//         indicatorColor: const Color(0xff3b17e8),
//         hintColor: const Color(0x8a000000),
//         errorColor: const Color(0xffd32f2f),
//         buttonTheme: const ButtonThemeData(
//           textTheme: ButtonTextTheme.normal,
//           minWidth: 88,
//           height: 36,
//           padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Color(0xff000000),
//               width: 0,
//               style: BorderStyle.none,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(2.0)),
//           ),
//         ),
//         textTheme: const TextTheme(
//           headline1: TextStyle(
//             color: Color(0x8a000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline2: TextStyle(
//             color: Color(0x8a000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline3: TextStyle(
//             color: Color(0x8a000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline4: TextStyle(
//             color: Color(0x8a000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline5: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline6: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           subtitle1: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           bodyText1: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           bodyText2: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           caption: TextStyle(
//             color: Color(0x8a000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           button: TextStyle(
//             color: Color(0xdd000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           subtitle2: TextStyle(
//             color: Color(0xff000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           overline: TextStyle(
//             color: Color(0xff000000),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//         ),
//       );
// }







//////////////////////////////////////////////////////  DARK  ////////////////////////////////////////////////////

// class ThemeDark extends ApplicationTheme {
//   static ThemeDark? _instance;
//   static ThemeDark get instance {
//     _instance ??= ThemeDark._init();
//     return _instance!;
//   }

//   ThemeDark._init();

//   @override
//   ThemeData? get theme => ThemeData(
//         extensions: <ThemeExtension<dynamic>>[
//           // your colors and styles
//         ],
//         primarySwatch: const MaterialColor(4280361249, {
//           50: Color(0xfff2f2f2),
//           100: Color(0xffe6e6e6),
//           200: Color(0xffcccccc),
//           300: Color(0xffb3b3b3),
//           400: Color(0xff999999),
//           500: Color(0xff808080),
//           600: Color(0xff666666),
//           700: Color(0xff4d4d4d),
//           800: Color(0xff333333),
//           900: Color(0xff191919)
//         }),
//         colorScheme: const ColorScheme.dark(
//           background: AppColors.darkBackground,
//         ),
//         fontFamily: AppFonts.lufgaFont,
//         fontFamilyFallback: const [AppFonts.gilroyFont],
//         brightness: Brightness.dark,
//         primaryColor: const Color(0xff212121),
//         primaryColorLight: const Color(0xff9e9e9e),
//         primaryColorDark: const Color(0xff000000),
//         canvasColor: const Color(0xff303030),
//         scaffoldBackgroundColor: const Color(0xff303030),
//         bottomAppBarColor: const Color(0xff424242),
//         cardColor: const Color(0xff424242),
//         dividerColor: const Color(0x1fffffff),
//         highlightColor: const Color(0x40cccccc),
//         splashColor: const Color(0x40cccccc),
//         selectedRowColor: const Color(0xfff5f5f5),
//         unselectedWidgetColor: const Color(0xb3ffffff),
//         disabledColor: const Color(0x62ffffff),
//         toggleableActiveColor: const Color(0xff64ffda),
//         secondaryHeaderColor: const Color(0xff616161),
//         backgroundColor: const Color(0xff616161),
//         dialogBackgroundColor: const Color(0xff424242),
//         indicatorColor: const Color(0xff64ffda),
//         hintColor: const Color(0x80ffffff),
//         errorColor: const Color(0xffd32f2f),
//         buttonTheme: const ButtonThemeData(
//           textTheme: ButtonTextTheme.normal,
//           minWidth: 88,
//           height: 36,
//           padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
//           shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Color(0xff000000),
//               width: 0,
//               style: BorderStyle.none,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(2.0)),
//           ),
//         ),
//         textTheme: const TextTheme(
//           headline1: TextStyle(
//             color: Color(0xb3ffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline2: TextStyle(
//             color: Color(0xb3ffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline3: TextStyle(
//             color: Color(0xb3ffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline4: TextStyle(
//             color: Color(0xb3ffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline5: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           headline6: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           subtitle1: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           bodyText1: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           bodyText2: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           caption: TextStyle(
//             color: Color(0xb3ffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           button: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           subtitle2: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//           overline: TextStyle(
//             color: Color(0xffffffff),
//             fontSize: null,
//             fontWeight: FontWeight.w400,
//             fontStyle: FontStyle.normal,
//           ),
//         ),
//       );
// }
