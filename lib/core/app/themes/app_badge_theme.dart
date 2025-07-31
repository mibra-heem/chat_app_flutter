import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AppBadgeTheme {
  const AppBadgeTheme._();

  static const light = BadgeThemeData(
    backgroundColor: Colours.badgeLight,
    offset: Offset.zero,
    textColor: Colours.white,
  );

  static const dark = BadgeThemeData(
    backgroundColor: Colours.badgeDark,
    offset: Offset.zero,
    textColor: Colours.white,
  );
}
