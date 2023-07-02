import 'package:aura/network/api/api_core.dart';

class UserPermissions implements Serializable {
  late bool _allowNotifications;
  late bool _allowLocationAccess;
  late bool _allowAutoCheckUpdates;

  UserPermissions({
    allowLocationAccess = false,
    allowNotifications = false,
    allowAutoCheckUpdates = false,
  }) {
    _allowNotifications = allowNotifications;
    _allowLocationAccess = allowLocationAccess;
    _allowAutoCheckUpdates = allowAutoCheckUpdates;
  }

  bool get allowNotifications => _allowNotifications;
  bool get allowLocationAccess => _allowLocationAccess;
  bool get allowAutoCheckUpdates => _allowAutoCheckUpdates;

  set setAllowNotifications(bool value) => _allowNotifications = value;
  set setAllowLocationAccess(bool value) => _allowLocationAccess = value;
  set setAllowAutoCheckUpdates(bool value) => _allowAutoCheckUpdates = value;

  @override
  Map<String, dynamic> toJson() {
    return {
      "allowNotifications": _allowNotifications,
      "allowLocationAccess": _allowLocationAccess,
      "allowAutoCheckUpdates": _allowAutoCheckUpdates,
    };
  }

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    json = json.cast<String, bool>();

    return UserPermissions(
      allowNotifications: json["allowNotifications"] ?? false,
      allowLocationAccess: json["allowLocationAccess"] ?? false,
      allowAutoCheckUpdates: json["allowAutoCheckUpdates"] ?? false,
    );
  }
}
