import 'package:flutter/material.dart';

class AppTheme {
  // 核心颜色定义 (莫兰迪色系)
  static const Color primaryGreen = Color(0xFF2C6957);
  static const Color lightGreen = Color(0xFFA8E6CF);
  static const Color lighterGreen = Color(0xFFDCEDC1);
  
  static const Color bgGray = Color(0xFFF9F9F9);
  static const Color cardWhite = Colors.white;
  
  static const Color textDark = Color(0xFF1A1C1C);
  static const Color textGray = Color(0xFF546073);
  static const Color textLightGray = Color(0xFF9CA3AF);

  static const Color expenseRed = Color(0xFFBA1A1A);
  static const Color warningOrange = Color(0xFFD97736);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgGray,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: lightGreen,
        background: bgGray,
        surface: cardWhite,
      ),
      fontFamily: 'system-ui', // 可以后续替换为特定字体
      appBarTheme: const AppBarTheme(
        backgroundColor: bgGray,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textDark, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textDark),
        bodyMedium: TextStyle(color: textGray),
      ),
    );
  }
}
