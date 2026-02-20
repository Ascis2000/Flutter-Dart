
import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // CONSTANTES COLORES LIGHT
  // =========================
  static const _primaryColor = Color.fromARGB(255, 143, 166, 189);
  static const _lightAppBarBGroundColor = Color.fromARGB(255, 137, 170, 211);
  static const _lightScaffoldBGroundColor = Color.fromARGB(255, 221, 230, 234);
  static const _lightCardColor = Colors.white;
  static const _lightCardShadowColor = Colors.black26;
  static const _lightElevatedButtonBG = _primaryColor;
  static const _lightElevatedButtonFG = Colors.white;
  static const _lightOutlinedButtonFG = _primaryColor;
  static const _lightOutlinedButtonBorder = _primaryColor;
  static const _lightTextButtonFG = _primaryColor;
  static const _lightInputFillColor = Colors.white;
  static const _lightSnackBarBG = Color.fromARGB(255, 102, 134, 185);
  static const _lightBottomNavBG = Colors.white;
  static const _lightBottomNavSelected = _primaryColor;
  static const _lightBottomNavUnselected = Colors.black54;

  // =========================
  // CONSTANTES COLORES DARK
  // =========================
  static const _darkPrimary = Color(0xFF546E7A);
  static const _darkAppBarBGroundColor = Color(0xFF1E1E1E);
  static const _darkScaffoldBGroundColor = Color(0xFF121212);
  static const _darkCardColor = Color(0xFF1E1E1E);
  static const _darkCardShadowColor = Colors.black;
  static const _darkElevatedButtonBG = _darkPrimary;
  static const _darkElevatedButtonFG = Colors.white;
  static const _darkOutlinedButtonFG = Colors.white;
  static const _darkOutlinedButtonBorder = Colors.white54;
  static const _darkTextButtonFG = Colors.white;
  static const _darkInputFillColor = Color(0xFF1E1E1E);
  static const _darkSnackBarBG = Colors.blueGrey;
  static const _darkBottomNavBG = Color(0xFF1E1E1E);
  static const _darkBottomNavSelected = Colors.white;
  static const _darkBottomNavUnselected = Colors.white54;

  // =========================
  // LIGHT THEME
  // =========================
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _lightScaffoldBGroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightAppBarBGroundColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: _lightCardColor,
      shadowColor: _lightCardShadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightElevatedButtonBG,
        foregroundColor: _lightElevatedButtonFG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        elevation: 3,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightOutlinedButtonFG,
        side: const BorderSide(color: _lightOutlinedButtonBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightTextButtonFG,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightInputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _lightSnackBarBG,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightBottomNavBG,
      selectedItemColor: _lightBottomNavSelected,
      unselectedItemColor: _lightBottomNavUnselected,
      elevation: 8,
    ),
  );


  // =========================
  // DARK THEME
  // =========================
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _darkScaffoldBGroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkAppBarBGroundColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      color: _darkCardColor,
      shadowColor: _darkCardShadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkElevatedButtonBG,
        foregroundColor: _darkElevatedButtonFG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        elevation: 3,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkOutlinedButtonFG,
        side: const BorderSide(color: _darkOutlinedButtonBorder, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkTextButtonFG,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkInputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _darkSnackBarBG,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkBottomNavBG,
      selectedItemColor: _darkBottomNavSelected,
      unselectedItemColor: _darkBottomNavUnselected,
      elevation: 8,
    ),
  );
}
