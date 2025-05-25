import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // Status bar color - Dark Teal
      statusBarIconBrightness: Brightness.light, // Status bar icons' color
    ),
    backgroundColor: AppColors.primary, // AppBar color - Dark Teal
    titleTextStyle: TextStyle(
      color: Colors.white, // Title color
      fontSize: 20, // Title font size
      fontWeight: FontWeight.bold, // Title font weight
    ),
    iconTheme: IconThemeData(
      color: Colors.white, // Icon color
    ),
    elevation: 0, // Modern flat design
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background, // Light Gray background
  primaryColor: AppColors.primary, // Dark Teal
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primary, // Dark Teal
    secondary: AppColors.secondary, // Warm Orange
    background: AppColors.background, // Light Gray
    surface: AppColors.cardBackground, // White for cards
  ),
  progressIndicatorTheme:
  ProgressIndicatorThemeData(color: AppColors.primary),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary, // Dark Teal
    foregroundColor: Colors.white,
  ),
  cardTheme: CardTheme(
    color: AppColors.cardBackground, // White cards
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: TextStyle(color: AppColors.primary),
    iconColor: AppColors.secondary, // Warm Orange icons
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2), // Dark Teal focus
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.textSecondary), // Light border
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    fillColor: AppColors.cardBackground, // White input background
    filled: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, // Dark Teal buttons
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary, // Dark Teal text buttons
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary, // Dark Teal outlined buttons
      side: BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textSecondary),
    labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  ),
  iconTheme: IconThemeData(
    color: AppColors.primary, // Dark Teal icons
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.textSecondary.withOpacity(0.3),
    thickness: 1,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.cardBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    type: BottomNavigationBarType.fixed,
  ),
);