import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppColorScheme {
  const AppColorScheme._();

  static const light = ColorScheme.light(
    primary: Colours.primary,
    primaryContainer: Colours.primaryBright,
    onPrimaryContainer: Colours.black,
    secondary: Colours.secondary,
    onSecondary: Colours.grey900,
    secondaryContainer: Colours.secondaryBright,
    onSecondaryContainer: Colours.grey100,
    tertiary: Colours.white,
    onTertiary: Colours.black,
    tertiaryContainer: Colours.grey300,
    onTertiaryContainer: Colours.grey700,
    surface: Colours.surfaceLight,
    surfaceContainer: Colours.white,
    surfaceDim: Colours.surfaceDimLight,
    surfaceBright: Colours.surfaceBrightLight,
  );

  static const dark = ColorScheme.dark(
    primary: Colours.primary,
    onPrimary: Colours.grey100,
    primaryContainer: Colours.primaryDim,
    onPrimaryContainer: Colours.white,
    secondary: Colours.secondary,
    onSecondary: Colours.grey900,
    secondaryContainer: Colours.secondaryBright,
    onSecondaryContainer: Colours.grey100,
    tertiary: Colours.grey900,
    onTertiary: Colours.white,
    tertiaryContainer: Colours.grey900,
    onTertiaryContainer: Colours.grey500,
    surfaceContainer: Colours.grey900,
    surfaceDim: Colours.surfaceDimDark,
    surfaceBright: Colours.surfaceBrightDark,

  );
}
