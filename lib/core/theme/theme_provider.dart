import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeProvider extends ChangeNotifier {
    ThemeData _themeData = lightTheme;

    ThemeData get themeData => _themeData;

    void toggleTheme(){
        _themeData = (_themeData == lightTheme) ? darkTheme : lightTheme;
        notifyListeners();
    }
}