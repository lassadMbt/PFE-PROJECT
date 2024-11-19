/* // lib/constants/ThemeProvider.dart

// Importing the necessary package
import 'package:flutter/material.dart';

// ThemeProvider class managing the app's theme
class ThemeProvider with ChangeNotifier {
  // Predefined light and dark themes
  ThemeData _lightTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );

  ThemeData _darkTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  // Getter for the current theme
  ThemeData get currentTheme => _isDarkTheme ? _darkTheme : _lightTheme;

  // Flag to track the current theme
  bool _isDarkTheme = false;

  // Placeholder for toggleTheme getter
  get toggleTheme => null;

  // Method to set the light theme
  void setLightTheme() {
    _isDarkTheme = false;
    notifyListeners(); // Notify listeners when the theme changes
  }

  // Method to set the dark theme
  void setDarkTheme() {
    _isDarkTheme = true;
    notifyListeners(); // Notify listeners when the theme changes
  }
} */