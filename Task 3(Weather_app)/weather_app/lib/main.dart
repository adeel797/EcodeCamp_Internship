import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/theme/theme.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("settings");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    loadThemeMode();
  }

  /// Loads the theme mode from the Hive box
  void loadThemeMode() {
    var box = Hive.box('settings');
    bool? isDarkMode = box.get('isDarkMode');
    if (isDarkMode != null) {
      setState(() {
        themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  /// Toggles the theme mode between light and dark
  void toggleThemeMode() {
    setState(() {
      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    saveThemeMode();
  }

  /// Saves the current theme mode to the Hive box
  void saveThemeMode() {
    var box = Hive.box('settings');
    box.put('isDarkMode', themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Forecast',
      home: HomeScreen(
        onThemeToggle: toggleThemeMode,
        isDarkMode: themeMode == ThemeMode.dark,
      ),
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: themeMode,
    );
  }
}
