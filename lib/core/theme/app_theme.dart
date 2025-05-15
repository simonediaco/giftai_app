import 'package:flutter/material.dart';

class AppTheme {
  // Colori primari
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryVariantColor = Color(0xFF3700B3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryVariantColor = Color(0xFF018786);
  
  // Colori di background
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  
  // Colori di superficie
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Colori di errore
  static const Color errorColor = Color(0xFFB00020);
  
  // Colori di testo
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFE1E1E1);
  static const Color textSecondaryDark = Color(0xFFAEAEAE);

  // Spaziature
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;

  // Elevazione
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryVariantColor,
        secondary: secondaryColor,
        onSecondary: Colors.black,
        secondaryContainer: secondaryVariantColor,
        background: backgroundLight,
        surface: surfaceLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryLight),
        displayMedium: TextStyle(color: textPrimaryLight),
        displaySmall: TextStyle(color: textPrimaryLight),
        headlineMedium: TextStyle(color: textPrimaryLight),
        headlineSmall: TextStyle(color: textPrimaryLight),
        titleLarge: TextStyle(color: textPrimaryLight),
        titleMedium: TextStyle(color: textPrimaryLight),
        titleSmall: TextStyle(color: textPrimaryLight),
        bodyLarge: TextStyle(color: textPrimaryLight),
        bodyMedium: TextStyle(color: textPrimaryLight),
        bodySmall: TextStyle(color: textSecondaryLight),
        labelLarge: TextStyle(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceM,
          ),
        ),
      ),
      // Aggiungi altri stili per button, input, card, ecc.
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryVariantColor,
        secondary: secondaryColor,
        onSecondary: Colors.black,
        secondaryContainer: secondaryVariantColor,
        background: backgroundDark,
        surface: surfaceDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        color: surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryDark),
        displayMedium: TextStyle(color: textPrimaryDark),
        displaySmall: TextStyle(color: textPrimaryDark),
        headlineMedium: TextStyle(color: textPrimaryDark),
        headlineSmall: TextStyle(color: textPrimaryDark),
        titleLarge: TextStyle(color: textPrimaryDark),
        titleMedium: TextStyle(color: textPrimaryDark),
        titleSmall: TextStyle(color: textPrimaryDark),
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textPrimaryDark),
        bodySmall: TextStyle(color: textSecondaryDark),
        labelLarge: TextStyle(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceM,
          ),
        ),
      ),
      // Aggiungi altri stili per il tema dark
    );
  }
}