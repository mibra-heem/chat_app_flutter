import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppIconButtonTheme {
  const AppIconButtonTheme._();

  static const light = IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colours.white),
      foregroundColor: WidgetStatePropertyAll(Colours.grey900),
    ),
  );

  static const dark = IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colours.grey900),
      foregroundColor: WidgetStatePropertyAll(Colours.white),
    ),
  );
}
