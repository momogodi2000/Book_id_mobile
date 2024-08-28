import 'package:flutter/material.dart';
import '../pages/panel/clients/setting/color.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeData get theme => _currentTheme;

  void setDarkTheme() {
    _currentTheme = ThemeData.dark();
    notifyListeners();
  }

  void setLightTheme() {
    _currentTheme = ThemeData.light();
    notifyListeners();
  }

  void setDefaultTheme() {
    _currentTheme = ThemeData(
      primaryColor: AppColors.defaultThemeColor,
      brightness: Brightness.light,
    );
    notifyListeners();
  }
}



