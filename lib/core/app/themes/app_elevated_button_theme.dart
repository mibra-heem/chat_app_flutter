import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppElevatedButtonTheme {
  const AppElevatedButtonTheme._();

  static const light = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colours.white),
      foregroundColor: WidgetStatePropertyAll(Colours.grey900),
    ),
  );

  static const dark = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colours.grey900),
      foregroundColor: WidgetStatePropertyAll(Colours.white),
    ),
  );
}
