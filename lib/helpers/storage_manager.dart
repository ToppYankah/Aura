import 'package:aura/resources/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorageManager {
  AppStorageManager._();

  static Future<bool> get isUserFirstTime async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isFirstTime =
        prefs.getBool(PreferenceKeys.IS_FIRST_TIME_LAUNCH);

    return isFirstTime ?? true;
  }

  static Future<void> get clear async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
