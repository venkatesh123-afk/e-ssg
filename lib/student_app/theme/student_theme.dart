import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Student app theme — completely separate from the staff app theme.
class StudentTheme {
  // 🎨 BRAND COLORS
  static const Color primary = Color(0xFF2563EB);
  static const Color accent = Color(0xFF00C896);
  static const Color danger = Color(0xFFFF6B6B);

  // ☀️ LIGHT MODE
  static const Color lightBackground = Colors.white; // Brand Blue
  static const Color lightCard = Colors.white;

  // 🌙 DARK MODE — container color matching design image
  static const Color darkBackground = Colors.black;
  static const Color darkCard = Color(0xFF383840); // dark gray as per image

  /// Helper: returns the container border color based on brightness.
  /// Dark mode → white border, Light mode → grey border.
  static Color containerBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.25)
        : Colors.grey.withOpacity(0.15);
  }

  /// Helper: returns white text color in dark mode, null (default) in light.
  static Color? adaptiveTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : null;
  }

  // ================= LIGHT THEME =================
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCard,
    dividerColor: Colors.grey.withOpacity(0.15),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: accent,
      error: danger,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  // ================= DARK THEME =================
  static ThemeData get darkTheme {
    final darkBase = ThemeData.dark();
    // Build a text theme with ALL styles forced to white
    final whiteTextTheme = GoogleFonts.poppinsTextTheme(
      darkBase.textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white);

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: primary,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      dividerColor: Colors.white.withOpacity(0.25),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: accent,
        error: danger,
        surface: darkCard,
        surfaceContainer: darkCard,
        onSurface: Colors.white,
      ),
      textTheme: whiteTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
