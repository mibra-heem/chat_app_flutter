import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppInputDecorationTheme {
  const AppInputDecorationTheme._();

  static const light = InputDecorationTheme(
    filled: true,
    fillColor: Colours.textFieldLight,
    
    counterStyle: TextStyle(
      color: Colours.primary,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    ),
    
    hintStyle: TextStyle(color: Colours.grey600),
    focusedBorder: InputBorder.none,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    suffixIconColor: Colours.black,
    prefixIconColor: Colours.black,
  );

  static const dark = InputDecorationTheme(
    filled: true,
    fillColor: Colours.textFieldDark,
    counterStyle: TextStyle(
      color: Colours.grey600,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: TextStyle(color: Colours.grey600),
    focusedBorder: InputBorder.none,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    suffixIconColor: Colours.white,
    prefixIconColor: Colours.white,
  );
}
