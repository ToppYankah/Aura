import 'dart:convert';
import 'dart:developer';
import 'package:aura/helpers/utils/settings_util.dart';
import 'package:aura/providers/base_provider.dart';
import 'package:aura/providers/settings/models/permissions_model.dart';
import 'package:aura/providers/settings/models/preferences_model.dart';
import 'package:aura/resources/app_strings.dart';

class SettingsProvider extends BaseProvider {
  SettingsProvider({required super.preferences, required super.apiCollection}) {
    _loadPreferenceSettings();
    _loadPermissionSettings();
  }

  // State variables ----------------------------------------------------------------------
  UserPreferences _preferences = UserPreferences();
  UserPermissions _permissions = UserPermissions();

  // Getters --------------------------------------------------------------------------------
  UserPreferences get prefs => _preferences;
  UserPermissions get permissions => _permissions;
  String get notificationTypeDescription {
    final typesLength = NotificationType.values.length;
    final selectedLength = _preferences.notificationTypes.length;

    if (typesLength == selectedLength) return "All notifications";

    final bool isEmpty = _preferences.notificationTypes.isEmpty;
    final bool isSingle = _preferences.notificationTypes.length == 1;

    if (isEmpty) return "All notifications disabled";

    return _preferences.notificationTypes
            .map((type) => SettingsUtil.notificationTypeString(type))
            .join(", ") +
        (isSingle ? " Only" : "");
  }

  // Setters --------------------------------------------------------------------------------
  // Permissions
  set allowNotifications(bool value) {
    _permissions.setAllowNotifications = value;
    update();
    _cachePermissionSettings();
  }

  set allowAutoCheckUpdates(bool value) {
    _permissions.setAllowAutoCheckUpdates = value;
    update();
    _cachePermissionSettings();
  }

  set allowLocationAccess(bool value) {
    _permissions.setAllowLocationAccess = value;
    update();
    _cachePermissionSettings();
  }

  // Preferences
  set refreshInterval(int value) {
    _preferences.setRefreshInterval = value;
    update();
    _cachePreferenceSettings();
  }

  set addNotificationType(NotificationType value) {
    _preferences.setNotificationType = value;
    update();
    _cachePreferenceSettings();
  }

  set removeNotificationType(NotificationType value) {
    _preferences.removeNotificationType = value;
    update();
    _cachePreferenceSettings();
  }

  set updateRefreshInterval(int interval) {
    _preferences.setRefreshInterval = interval;
    update();
    _cachePreferenceSettings();
  }

  // Methods --------------------------------------------------------------------------------
  void _cachePermissionSettings() {
    preferences.setString(
        PreferenceKeys.PERMISSION_SETTINGS, jsonEncode(_permissions.toJson()));
  }

  void _cachePreferenceSettings() {
    preferences.setString(
        PreferenceKeys.PREFERENCE_SETTINGS, jsonEncode(_preferences.toJson()));
  }

  void _loadPermissionSettings() {
    final String? cache =
        preferences.getString(PreferenceKeys.PERMISSION_SETTINGS);

    log("Preloading permession settings cache data...");
    if (cache != null && cache.isNotEmpty) {
      // Preset permissions data
      _permissions = UserPermissions.fromJson(jsonDecode(cache));
    }
  }

  void _loadPreferenceSettings() {
    final String? cache =
        preferences.getString(PreferenceKeys.PREFERENCE_SETTINGS);

    log("Preloading preference settings cache data...");
    if (cache != null && cache.isNotEmpty) {
      // Preset permissions data
      _preferences = UserPreferences.fromJson(jsonDecode(cache));
    }
  }

  String intervalDescription({bool explicit = false, int? value}) {
    int interval = value ?? _preferences.refreshInterval;
    switch (interval) {
      case 0:
        return explicit ? "Choose desired interval" : "off";
      default:
        return "${explicit ? "Every" : ""} $interval minute${interval > 1 ? "s" : ""}";
    }
  }
}
