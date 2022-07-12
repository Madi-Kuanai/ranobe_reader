import 'package:flutter/material.dart';
import 'package:ranobe_reader/settings/preferenceService.dart';

class MyTheme {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xff1C1B20),
      iconTheme: const IconThemeData(color: Color(0xff3E50FA)),
      primaryIconTheme: const IconThemeData(color: Color(0xff9FA4AA)),
      bottomAppBarColor: const Color(0xff2B2C30),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff1C1B20),
      ),
      colorScheme: const ColorScheme.light().copyWith(secondary: Colors.white10),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      chipTheme: const ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          disabledColor: Colors.white10),
      shadowColor: Colors.white);

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.lightBlue),
      primaryIconTheme: const IconThemeData(color: Color(0xff9FA4AA)),
      bottomAppBarColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.black26),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      shadowColor: Colors.black);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode =
      PreferenceService.isDarkMode() ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    isOn ? PreferenceService.setDarkMode() : PreferenceService.setLightMode();
    notifyListeners();
  }
}
