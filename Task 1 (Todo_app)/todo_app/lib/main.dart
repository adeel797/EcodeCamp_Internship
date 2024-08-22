import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/pages/homepage.dart';
import 'package:todo_app/themes/themes.dart';

/// Entry point of the Flutter application
Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("todoData");
  await Hive.openBox("settings");
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  /// Loads the theme mode from the Hive box
  void _loadThemeMode() {
    var box = Hive.box('settings');
    bool? isDarkMode = box.get('isDarkMode');
    if (isDarkMode != null) {
      setState(() {
        _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    }
  }

  /// Toggles the theme mode between light and dark
  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _saveThemeMode();
  }

  /// Saves the current theme mode to the Hive box
  void _saveThemeMode() {
    var box = Hive.box('settings');
    box.put('isDarkMode', _themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(
        onThemeToggle: _toggleThemeMode,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: _themeMode,
    );
  }
}
