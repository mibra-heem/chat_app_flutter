import 'package:flutter/material.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/core/res/fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: Fonts.poppins,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: Colours.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primaryColor,
      primary: Colours.primaryColor,
      secondary: Colours.lightWhite,
    ),
    applyElevationOverlayColor: false,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: Colours.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colours.primaryColor,
      actionsIconTheme: IconThemeData(color: Colours.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        surfaceTintColor: Colours.white,
        foregroundColor: Colours.black,
      ),
    ),
    dialogTheme: const DialogTheme(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colours.white,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: Colours.primaryColor,
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: Fonts.poppins,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colours.white,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colours.primaryColor,
      foregroundColor: Colours.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colours.white,
      surfaceTintColor: Colours.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colours.lightTextFieldColor,
      hintStyle: const TextStyle(color: Colours.black),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.lightTextFieldColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.lightTextFieldColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.lightTextFieldColor),
      ),
      suffixIconColor: Colours.black,
      prefixIconColor: Colours.black,
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: Fonts.poppins,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    primaryColor: Colours.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primaryColor,
      secondary: Colours.lightBlack,
      brightness: Brightness.dark,
    ),
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: Colours.black,
    splashFactory: NoSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(color: Colours.white),
        surfaceTintColor: Colours.white,
        foregroundColor: Colours.white,
      ),
    ),
    dialogTheme: const DialogTheme(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colours.lightBlack,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: Colours.white,
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: Fonts.poppins,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colours.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colours.primaryColor,
      foregroundColor: Colours.white,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.amber),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colours.black,
      selectedIconTheme: IconThemeData(color: Colours.white),
      selectedItemColor: Colours.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colours.darkTextFieldColor,
      hintStyle: const TextStyle(color: Colours.white),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.darkTextFieldColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.darkTextFieldColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.darkTextFieldColor),
      ),
      suffixIconColor: Colours.white,
      prefixIconColor: Colours.white,
    ),
  );
}
