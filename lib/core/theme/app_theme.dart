import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 PALETTE DONATELLO - Ispirata al maestro rinascimentale
  // Combinazione di viola/fucsia con tonalità calde e sofisticate
  
  // Colori primari - Viola Donatello (elegante e artistico)
  static const Color primaryColor = Color(0xFF7B68EE); // Slate Blue - più raffinato del fucsia
  static const Color primaryVariantColor = Color(0xFF6A5ACD); // Slate Blue più scuro
  static const Color secondaryColor = Color(0xFFDA70D6); // Orchid - mantiene il tuo fucsia preferito
  static const Color secondaryVariantColor = Color(0xFFBA55D3); // Medium Orchid
  
  // Accent colors - Tocchi dorati come i dettagli delle opere di Donatello
  static const Color accentColor = Color(0xFFFFD700); // Gold
  static const Color accentLightColor = Color(0xFFFFF8DC); // Cornsilk
  
  // Colori di background - Eleganti e sofisticati
  static const Color backgroundDark = Color(0xFF1A1A2E); // Navy scuro per eleganza
  static const Color backgroundLight = Color(0xFFFAFAFA); // Off-white più caldo
  
  // Colori di superficie - Texture marmorea
  static const Color surfaceDark = Color(0xFF2D2D44); // Grigio-viola scuro
  static const Color surfaceLight = Color(0xFFFFFFFF); // Bianco puro
  
  // Stati e feedback
  static const Color successColor = Color(0xFF4CAF50); // Verde naturale
  static const Color warningColor = Color(0xFFFF9800); // Arancione caldo
  static const Color errorColor = Color(0xFFE57373); // Rosso softened
  static const Color infoColor = Color(0xFF42A5F5); // Blu cielo
  
  // Testi - Contrasto perfetto
  static const Color textPrimaryLight = Color(0xFF212121); // Quasi nero
  static const Color textSecondaryLight = Color(0xFF757575); // Grigio medio
  static const Color textPrimaryDark = Color(0xFFFAFAFA); // Quasi bianco
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Grigio chiaro
  
  // Spaziature
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Border radius
  static const double borderRadiusS = 6.0;  // Leggermente più arrotondato
  static const double borderRadiusM = 12.0; // Più moderno
  static const double borderRadiusL = 20.0; // Più elegante
  static const double borderRadiusXL = 28.0;

  // Elevazione
  static const double elevationS = 2.0;
  static const double elevationM = 6.0;
  static const double elevationL = 12.0;
  static const double elevationXL = 20.0;

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryVariantColor,
        onPrimaryContainer: textPrimaryDark,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: secondaryVariantColor,
        onSecondaryContainer: textPrimaryDark,
        tertiary: accentColor,
        onTertiary: backgroundDark,
        tertiaryContainer: accentLightColor,
        onTertiaryContainer: backgroundDark,
        background: backgroundDark,
        onBackground: textPrimaryDark,
        surface: surfaceDark,
        onSurface: textPrimaryDark,
        surfaceVariant: surfaceDark,
        onSurfaceVariant: textSecondaryDark,
        error: errorColor,
        onError: Colors.white,
        errorContainer: errorColor,
        onErrorContainer: Colors.white,
        outline: textSecondaryDark,
        outlineVariant: textSecondaryDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textPrimaryDark),
        bodySmall: TextStyle(color: textSecondaryDark),
        labelLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceL,
          vertical: spaceM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide(
            color: textSecondaryDark.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(
            color: errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          elevation: elevationS,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceM,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusL),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXL,
            vertical: spaceM,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceL,
            vertical: spaceS,
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: elevationS,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        selectedColor: primaryColor.withValues(alpha: 0.2),
        disabledColor: textSecondaryDark.withValues(alpha: 0.1),
        labelStyle: const TextStyle(color: textPrimaryDark),
        secondaryLabelStyle: const TextStyle(color: primaryColor),
        side: BorderSide(color: textSecondaryDark.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: elevationM,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        elevation: elevationS,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: Color.fromARGB(26, 123, 104, 238), // primaryColor with 0.1 opacity
        onPrimaryContainer: primaryVariantColor,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: Color.fromARGB(26, 218, 112, 214), // secondaryColor with 0.1 opacity
        onSecondaryContainer: secondaryVariantColor,
        tertiary: accentColor,
        onTertiary: backgroundDark,
        tertiaryContainer: accentLightColor,
        onTertiaryContainer: backgroundDark,
        background: backgroundLight,
        onBackground: textPrimaryLight,
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        surfaceVariant: backgroundLight,
        onSurfaceVariant: textSecondaryLight,
        error: errorColor,
        onError: Colors.white,
        errorContainer: Color.fromARGB(26, 229, 115, 115), // errorColor with 0.1 opacity
        onErrorContainer: errorColor,
        outline: textSecondaryLight,
        outlineVariant: Color.fromARGB(128, 189, 189, 189), // textSecondaryLight with 0.5 opacity
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: textPrimaryLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimaryLight),
        bodyMedium: TextStyle(color: textPrimaryLight),
        bodySmall: TextStyle(color: textSecondaryLight),
        labelLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      ),
      // Rest of light theme configuration...
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceL,
          vertical: spaceM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide(color: textSecondaryLight.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: BorderSide(
            color: textSecondaryLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusL),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          elevation: elevationS,
          shadowColor: primaryColor.withValues(alpha: 0.3),
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

  // Utility methods per colori semantici
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return successColor;
      case 'warning':
      case 'pending':
        return warningColor;
      case 'error':
      case 'failed':
        return errorColor;
      case 'info':
      case 'processing':
        return infoColor;
      default:
        return primaryColor;
    }
  }

  static Color getMatchColor(int matchPercentage) {
    if (matchPercentage >= 90) return successColor;
    if (matchPercentage >= 70) return infoColor;
    if (matchPercentage >= 50) return warningColor;
    return errorColor;
  }
}