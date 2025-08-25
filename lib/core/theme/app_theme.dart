import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Light Theme Colors ---
  static const Color primaryColorLight = Color(0xFF1D2B44);
  static const Color accentColorLight = Color(0xFF4CAF50);
  static const Color backgroundColorLight = Color(0xFFF5F7FA);
  static const Color cardColorLight = Colors.white;

  // --- Dark Theme Colors ---
  static const Color primaryColorDark = Color(0xFFFFFFFF); // White text
  static const Color accentColorDark = Color(0xFF66BB6A); // Lighter Green
  static const Color backgroundColorDark = Color(0xFF121212); // Standard dark
  static const Color cardColorDark = Color(0xFF1E1E1E); // Slightly lighter dark

  // --- Light Theme Definition ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorLight,
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorLight,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      color: cardColorLight,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColorLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColorLight,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  // --- Dark Theme Definition ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // Dark card color for appbar
      foregroundColor: primaryColorDark, // White text
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      color: cardColorDark,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColorDark,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: accentColorDark,
      unselectedItemColor: Colors.grey,
      backgroundColor: cardColorDark,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),
  );
}
