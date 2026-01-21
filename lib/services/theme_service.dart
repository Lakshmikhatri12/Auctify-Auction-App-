import 'package:flutter/material.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() => _instance;

  ThemeService._internal();

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  void toggleTheme() {
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }

  void setTheme(ThemeMode mode) {
    themeNotifier.value = mode;
  }
}
