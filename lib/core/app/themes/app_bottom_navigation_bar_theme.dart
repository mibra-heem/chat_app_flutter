import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppBottomNavigationBarTheme {
  const AppBottomNavigationBarTheme._();

  static const light = BottomNavigationBarThemeData(
    backgroundColor: Colours.navBarLight,
    selectedIconTheme: IconThemeData(color: Colours.selectedItemLight),
    selectedItemColor: Colours.selectedItemLight,
  );

  static const dark = BottomNavigationBarThemeData(
    backgroundColor: Colours.navBarDark,
    selectedIconTheme: IconThemeData(color: Colours.selectedItemDark),
    selectedItemColor: Colours.selectedItemDark,
  );
}
