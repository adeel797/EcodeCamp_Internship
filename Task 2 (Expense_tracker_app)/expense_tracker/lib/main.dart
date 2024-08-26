import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'themes/themes.dart';

Future<void> main() async {
  // Initialize Hive and open the box
  await Hive.initFlutter();
  await Hive.openBox("transactionData");
  await Hive.openBox("settings");
  await Hive.openBox('budgetData');
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      title: "Expense Tracker",
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(
        onThemeToggle: toggleThemeMode,
        isDarkMode: themeMode == ThemeMode.dark,
      ),
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: themeMode,
    );
  }
}
