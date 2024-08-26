import 'package:flutter/material.dart';

/// Define the light theme for the application
ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0xFFEEEFF5),
    primary: Colors.black,
    secondary: Colors.white,
  ),
);

/// Define the dark theme for the application
ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey.shade700,
  ),
);
