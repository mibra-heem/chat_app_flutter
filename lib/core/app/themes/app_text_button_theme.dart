import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppTextButtonTheme {
  const AppTextButtonTheme._();

  static final light = TextButtonThemeData(
    style: TextButton.styleFrom(
      surfaceTintColor: Colours.white,
      foregroundColor: Colours.grey900,
    ),
  );

  static final dark = TextButtonThemeData(
    style: TextButton.styleFrom(
      surfaceTintColor: Colours.grey900,
      foregroundColor: Colours.grey100,
    ),
  );
}
