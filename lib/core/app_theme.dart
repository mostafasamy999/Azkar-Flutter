import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

final appTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.statusBarColor, // Status bar color
        statusBarIconBrightness: Brightness.light, // Status bar icons' color
      ),
      backgroundColor: AppColors.c4Actionbar, // AppBar color
      titleTextStyle: TextStyle(
        color: Colors.white, // Title color
        fontSize: 20, // Title font size
        fontWeight: FontWeight.bold, // Title font weight
      ),
      iconTheme: IconThemeData(
        color: Colors.white, // Icon color
      ),
    ),
    brightness: Brightness.light,
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: AppColors.primaryColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: AppColors.primaryColor),
        iconColor: AppColors.secondaryColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(8),
        )
    )
);
