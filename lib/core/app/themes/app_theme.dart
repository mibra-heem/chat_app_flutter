import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/resources/fonts.dart';
import 'package:mustye/core/app/themes/app_badge_theme.dart';
import 'package:mustye/core/app/themes/app_bottom_navigation_bar_theme.dart';
import 'package:mustye/core/app/themes/app_color_scheme.dart';
import 'package:mustye/core/app/themes/app_dialog_theme.dart';
import 'package:mustye/core/app/themes/app_divider_theme.dart';
import 'package:mustye/core/app/themes/app_elevated_button_theme.dart';
import 'package:mustye/core/app/themes/app_floating_action_button_theme.dart';
import 'package:mustye/core/app/themes/app_icon_button_theme.dart';
import 'package:mustye/core/app/themes/app_input_decoration_theme.dart';
import 'package:mustye/core/app/themes/app_popup_menu_theme.dart';
import 'package:mustye/core/app/themes/app_progress_indicator_bar_theme.dart';
import 'package:mustye/core/app/themes/app_text_button_theme.dart';
import 'package:mustye/core/app/themes/app_text_theme.dart';
import 'package:mustye/core/app/themes/my_app_bar_theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: Fonts.poppins,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: Colours.primary,
    colorScheme: AppColorScheme.light,
    applyElevationOverlayColor: false,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: Colours.surfaceLight,
    textTheme: AppTextTheme.light,
    appBarTheme: MyAppBarTheme.light,
    textButtonTheme: AppTextButtonTheme.light,
    dividerTheme: AppDividerTheme.light,
    dialogTheme: AppDialogTheme.light,
    elevatedButtonTheme: AppElevatedButtonTheme.light,
    iconButtonTheme: AppIconButtonTheme.light,
    badgeTheme: AppBadgeTheme.light,
    bottomNavigationBarTheme: AppBottomNavigationBarTheme.light,
    floatingActionButtonTheme: AppFloatingActionButtonTheme.light,
    popupMenuTheme: AppPopupMenuTheme.light,
    progressIndicatorTheme: AppProgressIndicatorBarTheme.light,
    inputDecorationTheme: AppInputDecorationTheme.light,
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: Fonts.poppins,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    primaryColor: Colours.primary,
    colorScheme: AppColorScheme.dark,
    applyElevationOverlayColor: false,
    scaffoldBackgroundColor: Colours.surfaceDark,
    splashFactory: NoSplash.splashFactory,
    textTheme: AppTextTheme.dark,
    textButtonTheme: AppTextButtonTheme.dark,
    dividerTheme: AppDividerTheme.dark,
    dialogTheme: AppDialogTheme.dark,
    elevatedButtonTheme: AppElevatedButtonTheme.dark,
    iconButtonTheme: AppIconButtonTheme.dark,
    popupMenuTheme: AppPopupMenuTheme.dark,
    badgeTheme: AppBadgeTheme.dark,
    appBarTheme: MyAppBarTheme.dark,
    floatingActionButtonTheme: AppFloatingActionButtonTheme.dark,
    bottomNavigationBarTheme: AppBottomNavigationBarTheme.dark,
    progressIndicatorTheme: AppProgressIndicatorBarTheme.dark,
    inputDecorationTheme: AppInputDecorationTheme.dark,
  );
}
