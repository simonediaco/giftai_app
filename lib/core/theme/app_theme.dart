import 'package:flutter/material.dart';

class AppTheme {
  // Colori primari
  static const Color primaryColor = Color(0xFFE040FB); // Fucsia accent
  static const Color primaryVariantColor = Color(0xFFD500F9);
  static const Color secondaryColor = Color(0xFFAB47BC); // Viola chiaro
  static const Color secondaryVariantColor = Color(0xFF9C27B0);

  // Colori di background
  static const Color backgroundDark = Color(0xFF1A1A2E); // Blu scuro
  static const Color backgroundLight = Color(0xFFF5F5F5);

  // Colori di superficie
  static const Color surfaceDark = Color(0xFF16213E); // Blu scuro più chiaro
  static const Color surfaceLight = Colors.white;

  // Colori di errore
  static const Color errorColor = Color(0xFFCF6679);

  // Colori di testo
  static const Color textPrimaryLight = Color(0xFFF8F9FA);
  static const Color textSecondaryLight = Color(0xFFB0B3B8);
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

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryVariantColor,
        secondary: secondaryColor,
        onSecondary: Colors.white,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceM,
          ),
        ),
      ),
    );
  }

  static ThemeData lightTheme() {
    return darkTheme(); // Per ora usiamo sempre il tema scuro
  }
}