import 'package:flutter/material.dart';

/// App color constants matching the design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF1E5AD7);
  static const Color primaryLight = Color(0xFF5B8EF5);

  // Background Colors
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF5F6FA);
  static const Color inputBackground = Color(0xFFF5F7FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF6F767E);
  static const Color textLight = Color(0xFF9A9FA5);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Income/Expense Colors
  static const Color income = Color(0xFF00D09E);
  static const Color expense = Color(0xFFFF6B6B);

  // Category Colors
  static const Color groceries = Color(0xFF6C63FF);
  static const Color entertainment = Color(0xFF2F6FED);
  static const Color gas = Color(0xFFFF6B9D);
  static const Color shopping = Color(0xFFFFC542);
  static const Color transport = Color(0xFFB4A5FF);
  static const Color rent = Color(0xFFFFB74D);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2F6FED),
    Color(0xFF5B8EF5),
  ];

  // Border Colors
  static const Color border = Color(0xFFE8ECF4);
  static const Color borderLight = Color(0xFFF0F2F5);

  // Status Colors
  static const Color success = Color(0xFF00D09E);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFC542);
  static const Color info = Color(0xFF2F6FED);

  // Shadow Colors
  static Color shadow = const Color(0xFF000000).withOpacity(0.08);
  static Color shadowDark = const Color(0xFF000000).withOpacity(0.15);
}
