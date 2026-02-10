import 'package:flutter/material.dart';

class ScreenState extends ChangeNotifier {
  String _currentScreen = 'main';

  String get currentScreen => _currentScreen;

  void changeScreen(String screenName) {
    _currentScreen = screenName;
    notifyListeners();
  }

  void resetToMain() {
    _currentScreen = 'main';
    notifyListeners();
  }
}
