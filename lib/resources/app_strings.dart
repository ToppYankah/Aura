// ignore_for_file: constant_identifier_names
class AppStrings {
  AppStrings._();

  /// This field is to be filled later
  static const String appStoreID = "...";
  static const String phoneScheme = 'tel';
  static const String appTitle = "Aura AQ";
  static const String mailScheme = 'mailto';
  static const String phone = "+233593598615";
  static const String mail = "tppyankah@gmail.com";
  static const String appleAuthProvider = "apple.com";
}

class AppRegex {
  static RegExp phone = RegExp(r"^[+]*[(]{0,1}[0-9]{7,}[)]{0,1}[-\s\./0-9]*$");
}

class AppFonts {
  static const String lufgaFont = "Lufga";
  static const String gilroyFont = "Gilroy";
}

class PreferenceKeys {
  PreferenceKeys._init();

  static const String COUNTRIES = "countries";
  static const String USER_COUNTRY = "userCountry";
  static const String IS_DARK_THEME = "isDarkTheme";
  static const String USER_LOCATION = "userLocation";
  static const String PERMISSION_SETTINGS = "permissionSettings";
  static const String PREFERENCE_SETTINGS = "preferenceSettings";
  static const String IS_FIRST_TIME_LAUNCH = "isFirstTimeLaunch";
  static const String HOME_SCREEN_TUTORIAL = "homeScreenTutorial";
  static const String MEASUREMENT_REFERENCE = "locationMeasurements";
  static const String CHOOSE_LOCATION_TUTORIAL = "chooseLocationTutorial";
}

class ExternalLinks {
  ExternalLinks._();

  static const String AQIWebsite = "https://www.airnow.gov/aqi/aqi-basics/";

  static const String airPollutionWebsite =
      "https://www.epa.gov/pm-pollution/particulate-matter-pm-basics#PM";
}

class FileRoots {
  FileRoots._();
  static const String darkMapStyle = "assets/styles/dark_map_styles.txt";
  static const String lightMapStyle = "assets/styles/light_map_styles.txt";
}

class AppStringImages {
  AppStringImages._();

  // icons
  static const goodMarker = "assets/images/icons/good-marker.png";
  static const moderateMarker = "assets/images/icons/moderate-marker.png";
  static const unhealthySFGMarker =
      "assets/images/icons/unhealthySFG-marker.png";
  static const unhealthyMarker = "assets/images/icons/unhealthy-marker.png";
  static const veryUnhealthyMarker =
      "assets/images/icons/veryUnhealthy-marker.png";
  static const hazardousMarker = "assets/images/icons/hazardous-marker.png";
}
