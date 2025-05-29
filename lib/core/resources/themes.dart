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
    primaryColor: Colours.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primary,
      surface: Colours.tileLight,
    ),
    applyElevationOverlayColor: false,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: Colours.scaffoldLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colours.appBarLight,
      actionsIconTheme: IconThemeData(color: Colours.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colours.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        surfaceTintColor: Colours.white,
        foregroundColor: Colours.grey900,
      ),
    ),
    dialogTheme: const DialogTheme(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colours.scaffoldLight,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: Colours.primary,
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: Fonts.poppins,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colours.navBarLight,
      type: BottomNavigationBarType.fixed,
      elevation: 1,
    ),  
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colours.primary,
      foregroundColor: Colours.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colours.white,
      surfaceTintColor: Colours.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colours.textFieldLight,
      hintStyle: const TextStyle(color: Colours.grey900),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldLight),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldLight),
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
    primaryColor: Colours.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primary,
      surface: Colours.tileDark,
      brightness: Brightness.dark,
    ),
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: Colours.scaffoldDark,
    splashFactory: NoSplash.splashFactory,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // textStyle: const TextStyle(color: Colours.white),
        surfaceTintColor: Colours.grey900,
        foregroundColor: Colours.grey100,
      ),
    ),
    dialogTheme: const DialogTheme(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colours.grey900,
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
      backgroundColor: Colours.appBarDark,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colours.primary,
      foregroundColor: Colours.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colours.navBarDark,
      selectedIconTheme: IconThemeData(color: Colours.white),
      selectedItemColor: Colours.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colours.textFieldDark,
      hintStyle: const TextStyle(color: Colours.grey100),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldDark),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colours.textFieldDark),
      ),
      suffixIconColor: Colours.white,
      prefixIconColor: Colours.white,
    ),
  );
}
