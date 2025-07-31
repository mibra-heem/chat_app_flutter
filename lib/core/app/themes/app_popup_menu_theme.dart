import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppPopupMenuTheme {
  const AppPopupMenuTheme._();

  static const light = PopupMenuThemeData(
    color: Colours.surfaceBrightLight,
    surfaceTintColor: Colours.grey100,
  );

  static const dark = PopupMenuThemeData(
    color: Colours.surfaceBrightDark,
    surfaceTintColor: Colours.grey900,
  );
}
