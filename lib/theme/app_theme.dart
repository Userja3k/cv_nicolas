import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFD91C2E); // Rouge de la navbar
  static const Color darkBg = Color(0xFF2C2C2C); // Gris foncé de l'image 3
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  static const Color textGrey = Color(0xFF888888);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        primary: AppColors.primaryRed,
        surface: AppColors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}