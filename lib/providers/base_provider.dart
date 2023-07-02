import 'package:aura/network/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider extends ChangeNotifier {
  String? _error;
  bool _loading = false;
  SharedPreferences preferences;
  late ApiCollection apiCollection;

  BaseProvider({required this.preferences, required this.apiCollection});

  void _update() => notifyListeners();
  VoidCallback get update => _update;

  void _startLoading() {
    _loading = true;
    update();
  }

  void _stopLoading() {
    _loading = false;
    update();
  }

  String? get error => _error;
  bool get isLoading => _loading;

  VoidCallback get stopLoading => _stopLoading;
  VoidCallback get startLoading => _startLoading;
  set setError(String? message) => _error = message;
}
