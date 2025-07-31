import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppDialogTheme {
  const AppDialogTheme._();

  static const light = DialogThemeData(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colours.surfaceLight,
  );

  static const dark = DialogThemeData(
    insetPadding: EdgeInsets.zero,
    backgroundColor: Colours.surfaceDark,
  );
}
