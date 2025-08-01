import 'package:flutter/material.dart';

class Colours {
  Colours._();

  static const gradient = [
    Color(0xFFEDF8FF),
    Color(0xFFFDC1E8),
    Color(0xFFFFFFFF),
    Color(0xFFFDFAE1),
  ];

  static const List<Color> productCardGradientLight = [grey100, grey300];
  static const List<Color> productCardGradientDark = [black, grey800];

  // Main colors
  static const primary = Color(0xFF3C1482);
  static const primaryBright = Color(0xFFEDD6F5);
  static const primaryDim = Color(0xFF2A0F5F);

  // Accent colors
  static const secondary = Color(0xFFFFC107);
  static const secondaryBright = Color(0xFFFFD54F);
  static const secondaryDim = Color(0xFFFFA000);

  // Neutral colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const red = Color(0xFFE74C3C);
  static const green = Color(0xFF34A33C);
  static const blue = Color(0xFF3498DB);
  static const yellow = Color(0xFFFFC107);
  static const grey = Color(0xFF9E9E9E);

  // Utility Colors
  static const success = green;
  static const info = blue;
  static const warning = yellow;
  static const danger = red;
  static const disable = grey600;
  static const neutral = grey;

  // Shades
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = grey;
  static const grey600 = Color(0xFF757575);
  static const grey700 = Color(0xFF616161);
  static const grey800 = Color(0xFF424242);
  static const grey900 = Color(0xFF212121);

  // App Colours

  // Scaffold Background Colours
  static const surfaceLight = Color(0xFEEFEFEE);
  static const surfaceDark = Color(0xFF121212);

  // Scaffold Background Bright Colour Shades
  static const surfaceBrightLight = white; // Old white
  static const surfaceBrightDark = Color(0xFF1E1E1E); // Old black

  // Scaffold Background Dim Colour Shades
  static const surfaceDimLight = Color(0xFFDADADA);
  static const surfaceDimDark = Color(0xFF0A0A0A); // Old 0xFF1E1E1E

  // Scaffold Foreground Colour i.e text colors
  static const onSurfaceLight = grey900;
  static const onSurfaceDark = grey100;

  // Container On Scaffold Colours i.e Card, Tiles
  static const surfaceContainerLight = white;
  static const surfaceContainerDark = grey900;

  // AppBar Colours
  static const appBarLight = primary;
  static const appBarDark = Color(0xFF1C1C1C);

  // Text Field Colours
  static const textFieldLight = surfaceBrightLight;
  static const textFieldDark = surfaceBrightDark;

  // Navigation Bar Colours
  static const navBarLight = Color(0xFFFAFAFA);
  static const navBarDark = Color(0xFF1A1A1A);

  // Selected Item Colours i.e Icon/Text in Navigation Bar
  static const selectedItemLight = primary;
  static const selectedItemDark = white;

  // Floating Action Button Colours
  static const floatingActionBtnLight = primary;
  static const floatingActionBtnDark = primary;

  // Badge Colours i.e on icons for showing counts
  static const badgeLight = primary;
  static const badgeDark = primary;
}
