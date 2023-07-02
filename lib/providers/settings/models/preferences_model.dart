import 'dart:collection';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/settings_util.dart';
import 'package:aura/network/api/api_core.dart';

class UserPreferences implements Serializable {
  late int _refreshInterval;
  late List<NotificationType> _notificationTypes;

  UserPreferences(
      {int refreshInterval = 5, List<int> notificationTypes = const [0]}) {
    _refreshInterval = refreshInterval;
    _notificationTypes =
        notificationTypes.map((e) => NotificationType.values[e]).toList();
  }

  int get refreshInterval => _refreshInterval;
  UnmodifiableListView<NotificationType> get notificationTypes =>
      UnmodifiableListView(_notificationTypes);

  set setRefreshInterval(int value) => _refreshInterval = value;
  set setNotificationType(NotificationType value) =>
      _notificationTypes.add(value);
  set removeNotificationType(NotificationType value) =>
      _notificationTypes.remove(value);

  @override
  Map<String, dynamic> toJson() {
    return {
      "refreshInterval": _refreshInterval,
      "notificationTypes": _notificationTypes.map((e) => e.index).toList(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationTypes: (json["notificationTypes"] ?? [0]).cast<int>(),
      refreshInterval:
          json["refreshInterval"] ?? CommonUtils.defaultRefreshInterval,
    );
  }
}
