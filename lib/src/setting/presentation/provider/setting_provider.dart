import 'package:flutter/material.dart';
import 'package:mustye/core/res/themes.dart';
import 'package:mustye/src/setting/domain/usecases/cache_dark_mode.dart';
import 'package:mustye/src/setting/domain/usecases/check_if_dark_mode_on.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider({
    required CacheDarkMode cacheDarkMode,
    required CheckIfDarkModeOn checkIfDarkModeOn,
  }) : _cacheDarkMode = cacheDarkMode,
       _checkIfDarkModeOn = checkIfDarkModeOn {
        
    loadInitialTheme();
    print('Initializing setting Provider......');
  }

  final CacheDarkMode _cacheDarkMode;
  final CheckIfDarkModeOn _checkIfDarkModeOn;

  ThemeData _theme = AppTheme.light;
  ThemeData get theme => _theme;

  bool get isDarkMode => _theme == AppTheme.dark;

  /// Toggles theme and persists user choice.
  Future<void> toggleTheme() async {
    _setTheme(isDarkMode ? AppTheme.light : AppTheme.dark);
    final result = await _cacheDarkMode(isDarkMode);
    result.fold(
      (failure) => debugPrint('Failed to cache theme: ${failure.errorMessage}'),
      (_) => null,
    );
  }

  /// Sets the theme and notifies listeners.
  void _setTheme(ThemeData newTheme) {
    _theme = newTheme;
    notifyListeners();
  }

  /// Loads cached theme preference at startup.
  Future<void> loadInitialTheme() async {
    final result = await _checkIfDarkModeOn();
    result.fold(
      (failure) =>
          debugPrint('Error loading cached theme: ${failure.errorMessage}'),
      (darkMode) => _setTheme(darkMode ? AppTheme.dark : AppTheme.light),
    );
  }
}
